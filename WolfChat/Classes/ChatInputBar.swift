//
//  ChatInputBar.swift
//  WolfChat
//
//  Created by Wolf McNally on 3/25/18.
//

import WolfCore

class ChatInputBar: View {
    var shouldReturn: TextView.PredicateBlock? {
        get { return textView.shouldReturn }
        set { textView.shouldReturn = newValue }
    }

    var text: String {
        get { return textView.text! }
        set {
            textView.text = newValue
            syncToText(animated: true)
        }
    }

    var placeholder: String? {
        get { return placeholderLabel.text }
        set { placeholderLabel.text = newValue }
    }

    var onSendButton: Block?

    func beginEditing() {
        textView.becomeFirstResponder()
    }

    private lazy var placeholderLabel = Label() • { 🍒 in
        🍒.text = "WolfChat"
        🍒.font = font
        🍒.textColor = frameGray
    }

    private lazy var backgroundView = View() • { 🍒 in
        let effectsView = ‡UIVisualEffectView(effect: UIBlurEffect(style: .light))
        self => [
            effectsView
        ]
        effectsView.constrainFrameToFrame()
    }

    private lazy var frameGray = try! UIColor(string: "#C7C7CC")

    private lazy var frameView = FrameView() • { 🍒 in
        🍒.style = .rounded(cornerRadius: 15)
        🍒.color = frameGray
        🍒.backgroundColor = .white
        //🍒.backgroundColor = UIColor.blue.withAlphaComponent(0.2)
    }

    private lazy var sendButtonImage = makeSendButtonImage()

    private var sendButtonAction: ControlAction<Button>!
    private lazy var sendButton = Button() • { 🍒 in
        🍒.setImage(self.sendButtonImage, for: [])
        self.sendButtonAction = addTouchUpInsideAction(to: 🍒) { _ in
            self.onSendButton?()
        }
    }

    private lazy var font = UIFont.systemFont(ofSize: 15)
    private lazy var lineHeight = ceil(font.lineHeight)

    private let maxVisibleLines = 5

    private class MyTextView: TextView {
        override func layoutSubviews() {
            super.layoutSubviews()
            textContainerInset = .zero
            textContainer.lineFragmentPadding = 0
        }
    }

    private lazy var textView = MyTextView() • { 🍒 in
        🍒.delegate = self
        🍒.font = font
        //🍒.text = "Hello, world!"
        🍒.isScrollEnabled = false
        //🍒.backgroundColor = UIColor.red.withAlphaComponent(0.2)
    }

    private var heightConstraint = Constraints()
    private var frameInsets = UIEdgeInsets(all: 4)
    private var textInsets = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 40)

    override func setup() {
        self => [
            backgroundView,
            frameView,
            placeholderLabel,
            textView,
            sendButton
        ]

        backgroundView.constrainFrameToFrame()
        frameView.constrainFrameToFrame(insets: CGInsets(edgeInsets: frameInsets))
        placeholderLabel.constrainFrameToFrame(insets: CGInsets(edgeInsets: textInsets))
        textView.constrainFrameToFrame(insets: CGInsets(edgeInsets: textInsets))
        heightConstraint = textView.constrainHeight(to: lineHeight)

        Constraints(
            sendButton.trailingAnchor == frameView.trailingAnchor - 4,
            sendButton.bottomAnchor == frameView.bottomAnchor - 4
        )
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        syncToText(animated: false)
    }

    private func syncHeight(animated: Bool) {
        let maxHeight = CGFloat(maxVisibleLines) * lineHeight

        func makeNewHeight() -> CGFloat {
            guard !textView.text.isEmpty else {
                return lineHeight
            }

            textView.setNeedsLayout()
            textView.layoutIfNeeded()

            let width = textView.bounds.width
            let size = textView.sizeThatFits(CGSize(width: width, height: .infinity))
            let height = ceil(size.height)
            let visibleLines = Int(ceil(height / lineHeight))
            if visibleLines > maxVisibleLines {
                return maxHeight
            } else {
                return CGFloat(visibleLines) * self.lineHeight
            }
        }

        let newHeight = makeNewHeight()

        if newHeight >= maxHeight {
            textView.isScrollEnabled = true
        } else {
            textView.isScrollEnabled = false
        }

        guard heightConstraint.constant != newHeight else { return }
        dispatchAnimated(animated, duration: 0.2) {
            self.heightConstraint.constant = newHeight
            self.superview!.layoutIfNeeded()
            }.run()
    }

    private func syncSendButton() {
        sendButton.isEnabled = text.count > 0
    }

    private func syncPlaceholder() {
        placeholderLabel.isHidden = text.count > 0
    }

    private func syncToText(animated: Bool) {
        syncHeight(animated: animated)
        syncSendButton()
        syncPlaceholder()
    }
}

extension ChatInputBar: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        syncToText(animated: true)
    }
}

private func makeSendButtonImage() -> UIImage {
    let width: CGFloat = 26
    let size = CGSize(width: width, height: width)

    //
    //     x3 x1 x2
    //  y1    .     }     }
    //       /!\    } d1  }
    //  y2  / | \   }     } d2
    //        |           }
    //  y3    |           }
    //
    let x1: CGFloat = 13
    let y1: CGFloat = 7.2
    let d1: CGFloat = 4.8
    let d2: CGFloat = 11.6
    let x2 = x1 + d1
    let x3 = x1 - d1
    let y2 = y1 + d1
    let y3 = y1 + d2
    let p = [
        (x1, y3), (x1, y1),
        (x2, y2), (x1, y1),
        (x3, y2), (x1, y1)
    ]
    let points = p.map { CGPoint(x: $0.0, y: $0.1) }

    return newImage(withSize: size, renderingMode: .alwaysTemplate) { context in
        context.fillEllipse(in: size.bounds)
        context.setBlendMode(.clear)
        context.setLineWidth(2.5)
        context.setLineCap(.round)
        context.strokeLineSegments(between: points)
    }
}

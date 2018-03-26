//
//  ChatInputBar.swift
//  WolfChat
//
//  Created by Wolf McNally on 3/25/18.
//

import WolfCore

private func makeSendButtonImage() -> UIImage {
    let width: CGFloat = 26
    let size = CGSize(width: width, height: width)
    return newImage(withSize: size, renderingMode: .alwaysTemplate) { context in
        context.fillEllipse(in: size.bounds)
    }
}

class ChatInputBar: View {
    private lazy var backgroundView = View() • { 🍒 in
        let effectsView = ‡UIVisualEffectView(effect: UIBlurEffect(style: .light))
        self => [
            effectsView
        ]
        effectsView.constrainFrameToFrame()
    }

    private lazy var frameView = FrameView() • { 🍒 in
        🍒.style = .rounded(cornerRadius: 15)
        🍒.color = try! UIColor(string: "#C7C7CC")
        🍒.backgroundColor = .white
        //🍒.backgroundColor = UIColor.blue.withAlphaComponent(0.2)
    }

    private lazy var sendButtonImage = makeSendButtonImage()

    private lazy var sendButton = Button() • { 🍒 in
        🍒.setImage(self.sendButtonImage, for: [])
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
        🍒.text = "Hello, world!"
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
            textView,
            sendButton
        ]

        backgroundView.constrainFrameToFrame()
        frameView.constrainFrameToFrame(insets: CGInsets(edgeInsets: frameInsets))
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

    private func syncToText(animated: Bool) {
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
            //print("lineHeight: \(lineHeight), height: \(height), visibleLines: \(visibleLines)")
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
}

extension ChatInputBar: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        syncToText(animated: true)
    }
}

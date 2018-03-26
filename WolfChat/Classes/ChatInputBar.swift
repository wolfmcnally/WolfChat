//
//  ChatInputBar.swift
//  WolfChat
//
//  Created by Wolf McNally on 3/25/18.
//

import WolfCore

class ChatInputBar: View {
    private lazy var placeholderView = PlaceholderView()

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
        🍒.backgroundColor = UIColor.red.lightened(by: 0.8)
        🍒.font = font
        🍒.text = "Hello, world!"
        🍒.isScrollEnabled = false
    }

    private var heightConstraint = Constraints()
    private var textInsets = UIEdgeInsets(all: 10)

    override func setup() {
        self => [
            placeholderView,
            textView
        ]

        placeholderView.constrainFrameToFrame()
        textView.constrainFrameToFrame(insets: CGInsets(edgeInsets: textInsets))
        heightConstraint = textView.constrainHeight(to: lineHeight)
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

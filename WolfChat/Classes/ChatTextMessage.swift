//
//  ChatTextMessage.swift
//  WolfChat
//
//  Created by Wolf McNally on 3/22/18.
//

import WolfCore

public struct ChatTextMessageStyle {
    public let textInsets: UIEdgeInsets
    public let widthFrac: CGFrac
    public let frameStyle: ChatFrameStyle

    public var shapeInsets: UIEdgeInsets {
        return frameStyle.shapeInsets
    }

    public init(textInsets: UIEdgeInsets, widthFrac: CGFrac, frameStyle: ChatFrameStyle) {
        self.textInsets = textInsets
        self.widthFrac = widthFrac
        self.frameStyle = frameStyle
    }
}

public struct ChatTextMessage: ChatMessage {
    public static let reuseIdentifier = "com.wolfmcnally.ChatText"
    public static let cellClass: AnyClass = ChatTextCell.self

    public let text: NSAttributedString
    public let style: ChatTextMessageStyle

    public init(text: NSAttributedString, style: ChatTextMessageStyle) {
        self.text = text
        self.style = style
        label.attributedText = text
        frameView = ChatFrameView(style: style.frameStyle)
    }

    let frameView: ChatFrameView

    let label = Label() • { 🍒 in
        🍒.numberOfLines = 0
    }

    public func cellSizeForWidth(_ width: CGFloat) -> CGSize {
        let textInsets = style.textInsets
        let effectiveWidth = width * style.widthFrac
        let shapeInsets = style.shapeInsets
        let maxTextWidth = effectiveWidth - textInsets.horizontal - shapeInsets.horizontal
        let textMaxBounds = CGSize(width: maxTextWidth, height: 10_000).bounds
        let textBounds = label.textRect(forBounds: textMaxBounds, limitedToNumberOfLines: 0)
        let cellHeight = textBounds.height + textInsets.vertical + shapeInsets.vertical
        let cellSize = CGSize(width: effectiveWidth, height: cellHeight)
        return cellSize
    }

    public var alignment: ChatMessageAlignment = .right
}

open class ChatTextCell: ChatCell {
    open override var reuseIdentifier: String? {
        return ChatPlaceholderMessage.reuseIdentifier
    }

    private var textMessage: ChatTextMessage {
        return message as! ChatTextMessage
    }

    private lazy var containerView = View()

    private var frameView: View {
        return textMessage.frameView
    }

    private var label: Label {
        return textMessage.label
    }

    private var textInsets: UIEdgeInsets {
        return textMessage.style.textInsets
    }

    private var shapeInsets: UIEdgeInsets {
        return textMessage.style.shapeInsets
    }

    open override func syncToMessage() {
        super.syncToMessage()

        stackView.removeAllSubviews()
        stackView => [
            containerView => [
                frameView,
                label
            ]
        ]

        frameView.constrainFrameToFrame()
        let insets = textInsets + shapeInsets
        label.constrainFrameToFrame(insets: CGInsets(edgeInsets: insets))
    }
}

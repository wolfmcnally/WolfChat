//
//  ChatTextItem.swift
//  WolfChat
//
//  Created by Wolf McNally on 3/22/18.
//

import WolfCore

public struct ChatTextItemStyle {
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

public struct ChatTextItem: ChatItem {
    public static let defaultReuseIdentifier = "com.wolfmcnally.ChatText"
    public static let cellClass: AnyClass = ChatTextCell.self

    public let text: NSAttributedString
    public let style: ChatTextItemStyle

    public init(text: NSAttributedString, style: ChatTextItemStyle) {
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

    public var alignment: ChatItemAlignment = .right
}

open class ChatTextCell: ChatCell {
    open override var reuseIdentifier: String? {
        return ChatTextItem.defaultReuseIdentifier
    }

    open override func setNeedsLayout() {
        super.setup()
    }

    private var textItem: ChatTextItem {
        return item as! ChatTextItem
    }

    private lazy var containerView = View()

    private var frameView: View {
        return textItem.frameView
    }

    private var label: Label {
        return textItem.label
    }

    private var textInsets: UIEdgeInsets {
        return textItem.style.textInsets
    }

    private var shapeInsets: UIEdgeInsets {
        return textItem.style.shapeInsets
    }

    open override func syncToItem() {
        super.syncToItem()

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

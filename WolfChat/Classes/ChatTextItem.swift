//
//  ChatTextItem.swift
//  WolfChat
//
//  Created by Wolf McNally on 3/22/18.
//

import WolfCore

public struct ChatTextItem: ChatItem {
    public static let defaultReuseIdentifier = "com.wolfmcnally.ChatText"
    public static let cellClass: AnyClass = ChatTextCell.self

    public let id = UUID()
    public let text: NSAttributedString
    public let style: ChatTextItemStyle
    public let alignment: ChatItemAlignment
    public let avatarView: UIView?

    public init(text: NSAttributedString, style: ChatTextItemStyle, alignment: ChatItemAlignment = .right, avatarView: UIView? = nil) {
        self.text = text
        self.style = style
        self.alignment = alignment
        self.avatarView = avatarView
        label.attributedText = text
        frameView = ChatFrameView(border: style.border)
    }

    let frameView: ChatFrameView

    let label = Label() • { 🍒 in
        🍒.numberOfLines = 0
    }

    public func sizeThatFits(_ size: CGSize) -> CGSize {
        avatarView?.layoutIfNeeded()
        let avatarSize: CGSize
        if let avatarView = avatarView {
            var s = avatarView.frame.size
            s.width += style.avatarSpacing
            avatarSize = s
        } else {
            avatarSize = .zero
        }
        let width = size.width
        let textInsets = style.textInsets
        let effectiveWidth = width * style.widthFrac
        let shapeInsets = style.shapeInsets
        let maxTextWidth = effectiveWidth - textInsets.horizontal - shapeInsets.horizontal - avatarSize.width
        let textMaxBounds = CGSize(width: maxTextWidth, height: 10_000).bounds
        let textBounds = label.textRect(forBounds: textMaxBounds, limitedToNumberOfLines: 0)
        let cellWidth = min(effectiveWidth, textBounds.width) + textInsets.horizontal + shapeInsets.horizontal + avatarSize.width
        let cellHeight = max(textBounds.height + textInsets.vertical + shapeInsets.vertical, avatarSize.height)
        let cellSize = CGSize(width: cellWidth, height: cellHeight)
        return cellSize
    }
}

public struct ChatTextItemStyle {
    public let textInsets: UIEdgeInsets
    public let widthFrac: CGFrac
    public let border: Border
    public let avatarSpacing: CGFloat

    public var shapeInsets: UIEdgeInsets {
        return border.insets
    }

    public init(textInsets: UIEdgeInsets, widthFrac: CGFrac, border: Border, avatarSpacing: CGFloat = 0) {
        self.textInsets = textInsets
        self.widthFrac = widthFrac
        self.border = border
        self.avatarSpacing = avatarSpacing
    }
}

open class ChatTextCell: ChatCell {
    open override var reuseIdentifier: String? {
        return ChatTextItem.defaultReuseIdentifier
    }

    private var textItem: ChatTextItem {
        return item as! ChatTextItem
    }

    private var frameView: View {
        return textItem.frameView
    }

    private var label: Label {
        return textItem.label
    }

    private var avatarView: UIView? {
        return textItem.avatarView
    }

    private var textInsets: UIEdgeInsets {
        return textItem.style.textInsets
    }

    private var shapeInsets: UIEdgeInsets {
        return textItem.style.shapeInsets
    }

    open override func prepareForReuse() {
        super.prepareForReuse()
        contentView.removeAllSubviews()
        stackView.removeAllSubviews()
        avatarContainerView.removeAllSubviews()
        textContainerView.removeAllSubviews()
    }

    private lazy var stackView = HorizontalStackView()
    private lazy var avatarContainerView = VerticalStackView()
    private lazy var textContainerView = View()

    open override func syncToItem() {
        super.syncToItem()

        contentView => [
            stackView => [
                textContainerView => [
                    frameView,
                    label
                ]
            ]
        ]

        stackView.spacing = textItem.style.avatarSpacing

        if let avatarView = avatarView {
            avatarContainerView => [
                View(), // To bottom-align avatar view
                avatarView
            ]
            switch textItem.alignment {
            case .left:
                stackView.insertArrangedSubview(avatarContainerView, at: 0)
            case .right:
                stackView.addArrangedSubview(avatarContainerView)
            case .center:
                preconditionFailure()
            }
        }

        stackView.constrainFrameToFrame()
        frameView.constrainFrameToFrame()
        let insets = textInsets + shapeInsets
        label.constrainFrameToFrame(insets: CGInsets(edgeInsets: insets))
    }
}

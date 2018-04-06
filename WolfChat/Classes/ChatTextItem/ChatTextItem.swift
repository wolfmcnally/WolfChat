//
//  ChatTextItem.swift
//  WolfChat
//
//  Created by Wolf McNally on 3/22/18.
//

import WolfCore

/// A fully-featured `ChatItem` used for representing text in a chat.
public struct ChatTextItem: ChatItem {
    public static let defaultReuseIdentifier = "com.wolfmcnally.ChatText"
    public static let cellClass: AnyClass = ChatTextCell.self

    public let id = UUID()
    public let text: NSAttributedString
    public let style: ChatTextItemStyle
    public let alignment: ChatItemAlignment
    public var horizontalInsets = UIEdgeInsets(horizontal: 10, vertical: 0)
    public let avatarView: UIView?

    public init(text: NSAttributedString, style: ChatTextItemStyle, alignment: ChatItemAlignment = .right, avatarView: UIView? = nil) {
        self.text = text
        self.style = style
        self.alignment = alignment
        self.avatarView = avatarView
        label.attributedText = text
        backgroundView = BorderBackgroundView(border: style.border)
    }

    let backgroundView: BorderBackgroundView

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

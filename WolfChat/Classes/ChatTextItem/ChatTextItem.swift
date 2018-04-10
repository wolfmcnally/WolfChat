//
//  ChatTextItem.swift
//  WolfChat
//
//  Created by Wolf McNally on 3/22/18.
//

import WolfCore

/// A fully-featured `ChatItem` used for representing text in a chat.
open class ChatTextItem: ChatItem {
    private typealias `Self` = ChatTextItem

    open override class var identifier: String { return "WolfChat.ChatText" }
    open override class var cellClass: AnyClass { return ChatTextCell.self }

    open class func styleForSender(_ sender: String) -> ChatTextItemStyle {
        fatalError("Override in subclass")
    }

    public private(set) var style: ChatTextItemStyle!
    public private(set) var avatarView: UIView?
    var backgroundView: BorderBackgroundView!

    enum CodingKeys: String, CodingKey {
        case sender
        case text
        case attributedText
    }

    public private(set) var sender: String!
    private var _text: String?
    private var _attributedText: NSAttributedString?

    public var text: String {
        if let attributedText = _attributedText {
            return attributedText.string
        } else if let text = _text {
            return text
        }
        return ""
    }

    public var attributedText: NSAttributedString {
        if let attributedText = _attributedText {
            return attributedText
        } else if let text = _text {
            let t = text§
            t.addAttributes(style.textAttributes)
            return t.copy() as! NSAttributedString
        }
        return NSAttributedString()
    }

    private func setup(style: ChatTextItemStyle, sender: String, text: String?, attributedText: NSAttributedString?) {
        alignment = style.alignment
        horizontalInsets = UIEdgeInsets(horizontal: 10, vertical: 0)
        self.style = style
        self.avatarView = style.makeAvatarView?(sender)
        self.backgroundView = BorderBackgroundView(border: style.border)
        self.sender = sender
        assert(text != nil || attributedText != nil)
        self._text = text
        self._attributedText = attributedText
        label.attributedText = self.attributedText
    }

    let label = Label() • { 🍒 in
        🍒.numberOfLines = 0
    }

    public init(date: Date, id: UUID, style: ChatTextItemStyle, sender: String, text: String? = nil, attributedText: NSAttributedString? = nil) {
        super.init(date: date, id: id)
        setup(style: style, sender: sender, text: text, attributedText: attributedText)
    }

    public required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let container = decoder[CodingKeys.self]
        let sender: String = container[.sender]!

        var text: String? = nil
        var attributedText: NSAttributedString? = nil

        if container.contains(.attributedText) {
            let data: Data = container[.attributedText]!
            attributedText = try NSAttributedString(data: data, options: [:], documentAttributes: nil)
        } else {
            text = container[.text]!
        }

        let style = type(of: self).styleForSender(sender)
        setup(style: style, sender: sender, text: text, attributedText: attributedText)
    }

    open override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder[CodingKeys.self]
        container[.sender] = sender
        if let attributedText = _attributedText {
            container[.attributedText] = try attributedText.data(from: attributedText.string.nsRange, documentAttributes: [:])
        } else {
            container[.text] = text
        }
    }

    open override func sizeThatFits(_ size: CGSize) -> CGSize {
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
        let borderInsets = style.border.insets
        let maxTextWidth = effectiveWidth - textInsets.horizontal - borderInsets.horizontal - avatarSize.width
        let textMaxBounds = CGSize(width: maxTextWidth, height: 10_000).bounds
        let textBounds = label.textRect(forBounds: textMaxBounds, limitedToNumberOfLines: 0)
        let cellWidth = min(effectiveWidth, textBounds.width) + textInsets.horizontal + borderInsets.horizontal + avatarSize.width
        let cellHeight = max(textBounds.height + textInsets.vertical + borderInsets.vertical, avatarSize.height)
        let cellSize = CGSize(width: cellWidth, height: cellHeight)
        return cellSize
    }
}

//
//  ChatTextItem.swift
//  WolfChat
//
//  Created by Wolf McNally on 3/22/18.
//

import WolfCore

/// A fully-featured `ChatItem` used for representing text in a chat.
open class ChatTextItem: ChatItem, Codable {
    private typealias `Self` = ChatTextItem

    public static let defaultReuseIdentifier = "com.wolfmcnally.ChatText"
    public static let cellClass: AnyClass = ChatTextCell.self
    public let style: ChatTextItemStyle

    enum CodingKeys: String, CodingKey {
        case id
        case date
        case sender
        case text
        case attributedText
    }

    public let id: UUID
    public let date: Date
    public let sender: String

    private let _text: String?
    private let _attributedText: NSAttributedString?

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

    public var alignment: ChatItemAlignment {
        return style.alignment
    }

    public var horizontalInsets = UIEdgeInsets(horizontal: 10, vertical: 0)
    public let avatarView: UIView?

    let backgroundView: BorderBackgroundView

    let label = Label() • { 🍒 in
        🍒.numberOfLines = 0
    }

    open class func styleForSender(_ sender: String) -> ChatTextItemStyle {
        fatalError("Override in subclass")
    }

    public init(style: ChatTextItemStyle, id: UUID, date: Date, sender: String, text: String? = nil, attributedText: NSAttributedString? = nil) {
        assert(text != nil || attributedText != nil)
        self.style = style
        self.id = id
        self.date = date
        self.sender = sender
        self._text = text
        self._attributedText = attributedText
        self.avatarView = style.makeAvatarView?(sender)
        self.backgroundView = BorderBackgroundView(border: style.border)
        label.attributedText = self.attributedText
    }

    public required convenience init(from decoder: Decoder) throws {
        let container = decoder[CodingKeys.self]
        let id: UUID = container[.id]!
        let date: Date = container[.date]!
        let sender: String = container[.sender]!

        var text: String? = nil
        var attributedText: NSAttributedString? = nil

        if container.contains(.attributedText) {
            let data: Data = container[.attributedText]!
            attributedText = try NSAttributedString(data: data, options: [:], documentAttributes: nil)
        } else {
            text = container[.text]!
        }

        let style = Self.styleForSender(sender)
        self.init(style: style, id: id, date: date, sender: sender, text: text, attributedText: attributedText)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder[CodingKeys.self]
        container[.id] = id
        container[.date] = date
        container[.sender] = sender
        if let attributedText = _attributedText {
            container[.attributedText] = try attributedText.data(from: attributedText.string.nsRange, documentAttributes: [:])
        } else {
            container[.text] = text
        }
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

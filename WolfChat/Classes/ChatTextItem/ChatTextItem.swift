//
//  ChatTextItem.swift
//  WolfChat
//
//  Created by Wolf McNally on 3/22/18.
//

import WolfCore

/// A fully-featured `ChatItem` used for representing text in a chat.
open class ChatTextItem: ChatItem {
    open override class var identifier: String { return "WolfChat.ChatText" }
    open override class var cellClass: AnyClass { return ChatTextCell.self }

    open class func styleForSender(_ sender: String) -> ChatTextItemStyle {
        fatalError("Override in subclass")
    }

    public private(set) var style: ChatTextItemStyle!
    public private(set) var avatarView: UIView?
    var backgroundView: BorderBackgroundView!

    enum CodingKeys: String, CodingKey {
        case text
        case attributedText
    }

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

    private func setup(style: ChatTextItemStyle, text: String?, attributedText: NSAttributedString?) {
        alignment = style.alignment
        horizontalInsets = UIEdgeInsets(horizontal: 10, vertical: 0)
        self.style = style
        self.avatarView = style.makeAvatarView?(sender)
        self.backgroundView = BorderBackgroundView(border: style.border)
        assert(text != nil || attributedText != nil)
        self._text = text
        self._attributedText = attributedText
        label.attributedText = self.attributedText
    }

    let label = Label() • { 🍒 in
        🍒.numberOfLines = 0
    }

    public init(date: Date, id: UUID, sender: String, style: ChatTextItemStyle, text: String? = nil, attributedText: NSAttributedString? = nil) {
        super.init(date: date, id: id, sender: sender)
        setup(style: style, text: text, attributedText: attributedText)
    }

    public required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let container = try decoder.container(keyedBy: CodingKeys.self)

        var text: String? = nil
        var attributedText: NSAttributedString? = nil

        if container.contains(.attributedText) {
            let data = try container.decode(Data.self, forKey: .attributedText)
            let documentAttributes: [NSAttributedString.DocumentAttributeKey: Any]? = [.documentType: NSAttributedString.DocumentType.rtf]
            var dict: NSDictionary? = documentAttributes as NSDictionary?
            attributedText = try NSAttributedString(data: data, options: [:], documentAttributes: &dict)
        } else {
            text = try container.decode(String.self, forKey: .text)
        }

        let style = type(of: self).styleForSender(sender)
        setup(style: style, text: text, attributedText: attributedText)
    }

    open override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        if let attributedText = _attributedText {
            let data = try attributedText.data(from: attributedText.string.nsRange, documentAttributes: [.documentType : NSAttributedString.DocumentType.rtf])
            try container.encode(data, forKey: .attributedText)
        } else {
            try container.encode(text, forKey: .text)
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

//
//  ChatPlaceholderItem.swift
//  WolfChat
//
//  Created by Wolf McNally on 3/22/18.
//

import WolfCore

/// A minimal sample `ChatItem`.
public class ChatPlaceholderItem: ChatItem {
    public override class var identifier: String { return "WolfChat.ChatPlaceholder" }
    public override class var cellClass: AnyClass { return ChatPlaceholderCell.self }

    private enum CodingKeys: String, CodingKey {
        case alignment
    }

    public init(date: Date, id: UUID, sender: String, alignment: ChatItemAlignment) {
        super.init(date: date, id: id, sender: sender)
        self.alignment = alignment
        setup()
    }

    private func setup() {
        horizontalInsets = UIEdgeInsets(horizontal: 10, vertical: 0)
    }

    public override func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize(width: size.width * 0.2, height: 50)
    }

    public required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        alignment = try container.decode(ChatItemAlignment.self, forKey: .alignment)
        setup()
    }

    public override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(alignment, forKey: .alignment)
    }
}

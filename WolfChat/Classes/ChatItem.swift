//
//  ChatItem.swift
//  WolfChat
//
//  Created by Wolf McNally on 3/22/18.
//

/// Represents an item that appears in the chat view.
/// Contains the model object(s) for the item.
/// Also knows how to measure for the collection cell that will be created for it.
/// Frequently contains the views that will be part of the collection view cell, as this
/// way they can be measured correctly using layout techniques (autolayout or similar).
open class ChatItem: Codable {
    open class var identifier: String { fatalError() }
    open class var cellClass: AnyClass { fatalError() }

    public var identifier: String { return type(of: self).identifier }
    public let date: Date
    public let id: UUID
    public let sender: String

    private enum CodingKeys: String, CodingKey {
        case identifier
        case id
        case date
        case sender
    }

    public init(date: Date, id: UUID, sender: String) {
        self.date = date
        self.id = id
        self.sender = sender
    }

    open func sizeThatFits(_ size: CGSize) -> CGSize { fatalError() }
    public var alignment: ChatItemAlignment = .right
    public var horizontalInsets: UIEdgeInsets = .zero

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        date = try container.decode(Date.self, forKey: .date)
        sender = try container.decode(String.self, forKey: .sender)
        let identifier = try container.decode(String.self, forKey: .identifier)
        assert(identifier == self.identifier)
    }

    open func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(identifier, forKey: .identifier)
        try container.encode(id, forKey: .id)
        try container.encode(date, forKey: .date)
        try container.encode(sender, forKey: .sender)
    }
}

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

    private enum CodingKeys: String, CodingKey {
        case identifier
        case id
        case date
    }

    public init(date: Date, id: UUID) {
        self.date = date
        self.id = id
    }

    open func sizeThatFits(_ size: CGSize) -> CGSize { fatalError() }
    public var alignment: ChatItemAlignment = .right
    public var horizontalInsets: UIEdgeInsets = .zero

    public required init(from decoder: Decoder) throws {
        let container = decoder[CodingKeys.self]
        id = container[.id]!
        date = container[.date]!
        assert(container[.identifier]! == identifier)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder[CodingKeys.self]
        container[.identifier] = identifier
        container[.id] = id
        container[.date] = date
    }
}

//
//  ChatState.swift
//  WolfChat
//
//  Created by Wolf McNally on 4/10/18.
//

open class ChatState: Codable {
    public private(set) var items: [ChatItem] = []

    private enum ItemsKey: CodingKey {
        case items
    }

    private enum IdentifierKey: CodingKey {
        case identifier
    }

    public init(items: [ChatItem]) {
        self.items = items
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: ItemsKey.self)
        try container.encode(items, forKey: .items)
    }

    open func decode(identifier: String, in arrayContainer: inout UnkeyedDecodingContainer) throws -> ChatItem {
        fatalError("Override in subclass.")
        //switch identifier {
        //case ChatPlaceholderItem.identifier:
        //    return try arrayContainer.decode(ChatPlaceholderItem.self)
        //case ChatTextItem.identifier:
        //    return try arrayContainer.decode(AppChatTextItem.self)
        //default:
        //    preconditionFailure()
        //}
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ItemsKey.self)
        var arrayContainerForType = try container.nestedUnkeyedContainer(forKey: .items)
        var arrayContainer = arrayContainerForType
        var items = [ChatItem]()
        while(!arrayContainerForType.isAtEnd) {
            let itemForType = try arrayContainerForType.nestedContainer(keyedBy: IdentifierKey.self)
            let identifier = try itemForType.decode(String.self, forKey: .identifier)
            try items.append(decode(identifier: identifier, in: &arrayContainer))
        }
        self.items = items
    }

    public func encode() throws -> Data {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        encoder.dateEncodingStrategy = .iso8601
        return try encoder.encode(self)
    }

    public func save(to url: URL) throws {
        let data = try encode()
        try data.write(to: url)
    }

    open class func load(from data: Data) throws -> ChatState {
        fatalError("Override in subclass.")
        //let decoder = JSONDecoder()
        //decoder.dateDecodingStrategy = .iso8601
        //return try decoder.decode(ChatState.self, from: data)
    }

    open class func load(from url: URL) throws -> ChatState {
        fatalError("Override in subclass.")
        //guard FileManager.default.isReadableFile(atPath: url.path) else {
        //    return ChatState(items: [])
        //}
        //let data = try Data(contentsOf: url)
        //return try load(from: data)
    }
}

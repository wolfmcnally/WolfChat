//
//  AppChatState.swift
//  WolfChat_Example
//
//  Created by Wolf McNally on 4/10/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import WolfChat

class AppChatState: ChatState {
    override func decode(identifier: String, in arrayContainer: inout UnkeyedDecodingContainer) throws -> ChatItem {
        switch identifier {
        case ChatPlaceholderItem.identifier:
            return try arrayContainer.decode(ChatPlaceholderItem.self)
        case ChatTextItem.identifier:
            return try arrayContainer.decode(AppChatTextItem.self)
        default:
            preconditionFailure()
        }
    }

    public override class func load(from data: Data) throws -> AppChatState {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try decoder.decode(AppChatState.self, from: data)
    }

    public override static func load(from url: URL) throws -> AppChatState {
        guard FileManager.default.isReadableFile(atPath: url.path) else {
            return AppChatState(items: [])
        }
        let data = try Data(contentsOf: url)
        return try load(from: data)
    }
}

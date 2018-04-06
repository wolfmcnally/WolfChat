//
//  ChatPlaceholderItem.swift
//  WolfChat
//
//  Created by Wolf McNally on 3/22/18.
//

import WolfCore

/// A minimal sample `ChatItem`.
public struct ChatPlaceholderItem: ChatItem {

    public static let defaultReuseIdentifier = "com.wolfmcnally.ChatPlaceholder"
    public static let cellClass: AnyClass = ChatPlaceholderCell.self

    enum CodingKeys: String, CodingKey {
        case id
        case date
        case alignment
    }

    public let id = UUID()
    public let date = Date()

    public init() {
    }

    public func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize(width: size.width * 0.2, height: 50)
    }

    public var alignment: ChatItemAlignment = .right
    public var horizontalInsets = UIEdgeInsets(horizontal: 10, vertical: 0)
}

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

    public let id = UUID()

    public init() {
    }

    public func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize(width: size.width * 0.2, height: 50)
    }

    public var alignment: ChatItemAlignment = .right
    public var horizontalInsets = UIEdgeInsets(horizontal: 10, vertical: 0)
}

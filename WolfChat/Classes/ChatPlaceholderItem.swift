//
//  ChatPlaceholderItem.swift
//  WolfChat
//
//  Created by Wolf McNally on 3/22/18.
//

import WolfCore

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
}

open class ChatPlaceholderCell: ChatCell {
    private lazy var placeholderView = PlaceholderView(title: "😎")

    open override var reuseIdentifier: String? {
        return ChatPlaceholderItem.defaultReuseIdentifier
    }

    open override func setup() {
        super.setup()

        contentView => [
            placeholderView
        ]

        placeholderView.constrainFrameToFrame()
    }
}

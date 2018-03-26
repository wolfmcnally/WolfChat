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

    public init() {
    }

    public func setupCell(_ cell: ChatCell) {
    }

    public func cellSizeForWidth(_ width: CGFloat) -> CGSize {
        return CGSize(width: width * 0.2, height: 50)
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

        stackView => [
            placeholderView
        ]
    }
}

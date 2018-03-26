//
//  ChatPlaceholderMessage.swift
//  WolfChat
//
//  Created by Wolf McNally on 3/22/18.
//

import WolfCore

public struct ChatPlaceholderMessage: ChatMessage {
    public static let reuseIdentifier = "com.wolfmcnally.ChatPlaceholder"
    public static let cellClass: AnyClass = ChatPlaceholderCell.self

    public init() {
    }

    public func setupCell(_ cell: ChatCell) {
    }

    public func cellSizeForWidth(_ width: CGFloat) -> CGSize {
        return CGSize(width: width * 0.2, height: 50)
    }

    public var alignment: ChatMessageAlignment = .right
}

open class ChatPlaceholderCell: ChatCell {
    open override var reuseIdentifier: String? {
        return ChatPlaceholderMessage.reuseIdentifier
    }

    private lazy var placeholderView = PlaceholderView(title: "😎")

    open override func setup() {
        super.setup()

        stackView => [
            placeholderView
        ]
    }
}

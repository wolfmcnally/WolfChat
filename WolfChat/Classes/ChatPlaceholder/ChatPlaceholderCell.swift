//
//  ChatPlaceholderCell.swift
//  Pods
//
//  Created by Wolf McNally on 4/1/18.
//

import WolfCore

/// A minimal sample `ChatCell`.
open class ChatPlaceholderCell: ChatCell {
    private lazy var placeholderView = PlaceholderView(title: "😎")

    open override var reuseIdentifier: String? {
        return ChatPlaceholderItem.identifier
    }

    open override func setup() {
        super.setup()

        contentView => [
            placeholderView
        ]

        placeholderView.constrainFrameToFrame()
    }
}

//
//  ChatCell.swift
//  WolfChat
//
//  Created by Wolf McNally on 3/22/18.
//

import WolfCore

open class ChatCell: CollectionViewCell {
    public var message: ChatMessage! {
        didSet { syncToMessage() }
    }

    open override var reuseIdentifier: String? {
        return "com.wolfmcnally.ChatCell"
    }

    open func syncToMessage() {
    }

    private(set) lazy var stackView = HorizontalStackView()

    open override func setup() {
        contentView => [
            stackView
        ]

        stackView.constrainFrameToFrame()
    }
}

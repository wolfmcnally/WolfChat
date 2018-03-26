//
//  ChatCell.swift
//  WolfChat
//
//  Created by Wolf McNally on 3/22/18.
//

import WolfCore

open class ChatCell: CollectionViewCell {
    public var item: ChatItem! {
        didSet { syncToMessage() }
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

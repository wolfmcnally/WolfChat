//
//  ChatCell.swift
//  WolfChat
//
//  Created by Wolf McNally on 3/22/18.
//

import WolfCore

open class ChatCell: CollectionViewCell {
    public var item: ChatItem! {
        didSet { syncToItem() }
    }

    open func syncToItem() {
    }
}

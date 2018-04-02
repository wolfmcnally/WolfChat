//
//  ChatCell.swift
//  WolfChat
//
//  Created by Wolf McNally on 3/22/18.
//

import WolfCore

/// This is the collection view cell that appears in the chat view.
/// Holds a reference to the `ChatItem`, which contains the model object(s).
open class ChatCell: CollectionViewCell {
    public var item: ChatItem! {
        didSet { syncToItem() }
    }

    open func syncToItem() {
    }
}

//
//  ChatView.swift
//  WolfChat
//
//  Created by Wolf McNally on 3/22/18.
//

import WolfCore

public class ChatView: View {
    private lazy var collectionView = ChatCollectionView()

    public var margins: UIEdgeInsets {
        get { return collectionView.margins }
        set { collectionView.margins = newValue }
    }

    public func register<T: ChatMessage>(messageClass: T.Type) {
        collectionView.register(messageClass.cellClass, forCellWithReuseIdentifier: messageClass.reuseIdentifier)
    }

    public func addMessage(_ message: ChatMessage, animated: Bool) {
        collectionView.addMessage(message, animated: animated)
    }

    public override func setup() {
        self => [
            collectionView
        ]

        collectionView.constrainFrameToFrame()
    }
}

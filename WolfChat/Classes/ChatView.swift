//
//  ChatView.swift
//  WolfChat
//
//  Created by Wolf McNally on 3/22/18.
//

import WolfCore

public class ChatView: View {
    private lazy var keyboardAvoidantView = KeyboardAvoidantView()
    private lazy var collectionView = ChatCollectionView()
    private lazy var inputBarView = ChatInputBar()

    public var margins: UIEdgeInsets {
        get { return collectionView.margins }
        set { collectionView.margins = newValue }
    }

    public func register<T: ChatItem>(messageClass: T.Type) {
        collectionView.register(messageClass.cellClass, forCellWithReuseIdentifier: messageClass.defaultReuseIdentifier)
    }

    @discardableResult public func addItem(_ item: ChatItem, animated: Bool) -> IndexPath {
        return collectionView.addItem(item, animated: animated)
    }

    public func scrollToItem(at indexPath: IndexPath, at position: UICollectionViewScrollPosition, animated: Bool) {
        collectionView.scrollToItem(at: indexPath, at: position, animated: animated)
    }

    public override func setup() {
        self => [
            keyboardAvoidantView => [
                collectionView,
                inputBarView
            ]
        ]

        keyboardAvoidantView.constrainFrameToFrame(priority: .defaultHigh)
        collectionView.constrainFrameToFrame()
        Constraints(
            inputBarView.leadingAnchor == keyboardAvoidantView.leadingAnchor,
            inputBarView.trailingAnchor == keyboardAvoidantView.trailingAnchor,
            inputBarView.bottomAnchor == keyboardAvoidantView.bottomAnchor
        )
    }

    public override func layoutSubviews() {
        super.layoutSubviews()

        inputBarView.layoutIfNeeded()
        let height = inputBarView.frame.height
        collectionView.contentInset.bottom = height
    }
}

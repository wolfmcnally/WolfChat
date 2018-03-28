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

    public var shouldReturn: TextView.PredicateBlock? {
        get { return inputBarView.shouldReturn }
        set { inputBarView.shouldReturn = newValue }
    }

    public var onSendButton: Block? {
        get { return inputBarView.onSendButton }
        set { inputBarView.onSendButton = newValue }
    }

    public var text: String {
        get { return inputBarView.text }
        set { inputBarView.text = newValue }
    }

    public var placeholder: String? {
        get { return inputBarView.placeholder }
        set { inputBarView.placeholder = newValue }
    }

    public var inputBarLeftView: UIView? {
        get { return inputBarView.leftView }
        set { inputBarView.leftView = newValue }
    }

    public var inputBarRightView: UIView? {
        get { return inputBarView.rightView }
        set { inputBarView.rightView = newValue }
    }

    public var inputBarTopView: UIView? {
        get { return inputBarView.topView }
        set { inputBarView.topView = newValue }
    }

    public func removeText() {
        text.removeAll()
    }

    public func beginEditing() {
        inputBarView.beginEditing()
    }

    @discardableResult public func addItem(_ item: ChatItem) -> IndexPath {
        return collectionView.addItem(item)
    }

    public func scrollToItem(at indexPath: IndexPath, at position: UICollectionViewScrollPosition, animated: Bool) {
        collectionView.scrollToItem(at: indexPath, at: position, animated: animated)
    }

    public func scrollToBottom(animated: Bool) {
        collectionView.scrollToBottom(animated: animated)
    }

    private var inputBarDidChangeHeightObserver: ChatInputBar.DidChangeHeight.Observer!

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
            inputBarView.bottomAnchor <= keyboardAvoidantView.bottomAnchor,
            inputBarView.bottomAnchor == safeAreaLayoutGuide.bottomAnchor =&= .defaultHigh
        )

        inputBarDidChangeHeightObserver = inputBarView.didChangeHeight.add {
            self.setNeedsLayout()
            self.layoutIfNeeded()
            self.scrollToBottom(animated: true)
        }
    }

    public override func layoutSubviews() {
        super.layoutSubviews()

        inputBarView.layoutIfNeeded()
        let height = inputBarView.frame.height
        collectionView.contentInset.bottom = height
    }
}

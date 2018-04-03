//
//  ChatView.swift
//  WolfChat
//
//  Created by Wolf McNally on 3/22/18.
//

import WolfCore

/// The main view that contains a scrolling history of the chat.
public class ChatView: View {
    private lazy var keyboardAvoidantView = KeyboardAvoidantView()

    private lazy var collectionView = ChatCollectionView() • {
        $0.contentInsetAdjustmentBehavior = .never
    }

    private lazy var inputBarView = ChatInputBar()

    public var spacing: CGFloat {
        get { return collectionView.spacing }
        set { collectionView.spacing = newValue }
    }
    
    public var verticalInsets: UIEdgeInsets {
        get { return collectionView.verticalInsets }
        set { collectionView.verticalInsets = newValue }
    }

    public func register<T: ChatItem>(messageClass: T.Type) {
        collectionView.register(messageClass.cellClass, forCellWithReuseIdentifier: messageClass.defaultReuseIdentifier)
    }

    public var shouldReturn: TextView.PredicateBlock? {
        get { return inputBarView.shouldReturn }
        set { inputBarView.shouldReturn = newValue }
    }

    public var shouldChangeText: ((String, StringRange, String) -> Bool)? {
        get { return inputBarView.shouldChangeText }
        set { inputBarView.shouldChangeText = newValue }
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
    }

    public func setInputBarLeftView(_ view: UIView?, animated: Bool) {
        inputBarView.setLeftView(view, animated: animated)
    }

    public var inputBarRightView: UIView? {
        get { return inputBarView.rightView }
    }

    public func setInputBarRightView(_ view: UIView?, animated: Bool) {
        inputBarView.setRightView(view, animated: animated)
    }

    public var inputBarTopView: UIView? {
        get { return inputBarView.topView }
    }

    public func setInputBarTopView(_ view: UIView?, animated: Bool) {
        inputBarView.setTopView(view, animated: animated)
    }

    public var inputBarFont: UIFont {
        get { return inputBarView.font }
        set { inputBarView.font = newValue }
    }

    public var inputBarPlaceholderColor: UIColor {
        get { return inputBarView.placeholderColor }
        set { inputBarView.placeholderColor = newValue }
    }

    public var inputBarTextColor: UIColor {
        get { return inputBarView.textColor }
        set { inputBarView.textColor = newValue }
    }

    public func removeText() {
        text.removeAll()
    }

    public func beginEditing() {
        inputBarView.beginEditing()
    }

    @discardableResult public func addItem(_ item: ChatItem) -> UUID {
        return collectionView.addItem(item)
    }

    public func removeItem(id: UUID) {
        collectionView.removeItem(id: id)
    }

    public func scrollToItem(at indexPath: IndexPath, at position: UICollectionViewScrollPosition, animated: Bool) {
        collectionView.scrollToItem(at: indexPath, at: position, animated: animated)
    }

    public func scrollToBottom(animated: Bool) {
        collectionView.scrollToBottom(animated: animated)
    }

    private var inputBarDidChangeHeightObserver: ChatInputBar.DidChangeHeight.Observer!
    private var inputBarWillChangeHeightObserver: ChatInputBar.WillChangeHeight.Observer!

    public override func setup() {
        self => [
            keyboardAvoidantView => [
                collectionView,
                inputBarView
            ]
        ]

        keyboardAvoidantView.constrainFrameToFrame(priority: .defaultHigh)
        Constraints(
            collectionView.topAnchor == keyboardAvoidantView.topAnchor,
            collectionView.bottomAnchor == keyboardAvoidantView.bottomAnchor,
            collectionView.leadingAnchor == keyboardAvoidantView.safeAreaLayoutGuide.leadingAnchor,
            collectionView.trailingAnchor == keyboardAvoidantView.safeAreaLayoutGuide.trailingAnchor
        )

        Constraints(
            inputBarView.leadingAnchor == keyboardAvoidantView.leadingAnchor,
            inputBarView.trailingAnchor == keyboardAvoidantView.trailingAnchor,
            inputBarView.bottomAnchor <= keyboardAvoidantView.bottomAnchor,
            inputBarView.bottomAnchor == safeAreaLayoutGuide.bottomAnchor =&= .defaultHigh
        )

        inputBarWillChangeHeightObserver = inputBarView.willChangeHeight.add {
            self.setNeedsLayout()
            self.layoutIfNeeded()
        }

        inputBarDidChangeHeightObserver = inputBarView.didChangeHeight.add {
            let inputBarHeight = self.inputBarView.frame.height
            let bottomSafeInset = self.safeAreaInsets.bottom
            let height = inputBarHeight + bottomSafeInset
            self.collectionView.contentInset.bottom = height
            self.layoutIfNeeded()
            self.scrollToBottom(animated: true)
        }
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.contentInset.top = safeAreaInsets.top
    }
}

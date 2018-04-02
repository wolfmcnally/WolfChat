//
//  ChatCollectionView.swift
//  WolfChat
//
//  Created by Wolf McNally on 3/22/18.
//

import WolfCore
import UIKit

/// The UICollectionView that contains the `ChatCell`s that represent `ChatItem`s.
/// You typically won't directly access the `ChatCollectionView`-- methods to access its
/// configurable attributes are found on its containing `ChatView`.
class ChatCollectionView: CollectionView {
    var messages: [ChatItem] = []

    private let layout = ChatCollectionViewLayout()

    var spacing: CGFloat {
        get { return layout.spacing }
        set { layout.spacing = newValue }
    }

    var verticalInsets: UIEdgeInsets {
        get { return layout.verticalInsets }
        set { layout.verticalInsets = newValue }
    }

    func addItem(_ item: ChatItem) -> UUID {
        let indexPath = IndexPath(item: messages.count, section: 0)
        messages.append(item)
        if self.messages.count == 1 {
            self.reloadData()
        } else {
//            dispatchAnimated(duration: 0.2) {
                self.performBatchUpdates( {
                    self.insertItems(at: [indexPath])
                }, completion: { _ in
                    self.scrollToBottom(animated: true)
                } )
//            }.run()
        }
        return item.id
    }

    func removeItem(id: UUID) {
        let index = messages.index(where: { $0.id == id })!
        let indexPath = IndexPath(item: index, section: 0)
        self.messages.remove(at: index)
        performBatchUpdates({
            self.deleteItems(at: [indexPath])
            let context = ChatCollectionViewLayout.InvalidationContext()
            context.invalidateItems(at: [indexPath])
            layout.invalidateLayout(with: context)
        }, completion: { _ in
        })
    }

    init() {
        super.init(collectionViewLayout: layout)
        alwaysBounceVertical = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setup() {
        dataSource = self
        delegate = self
        endsEditingWhenTapped = true
        //layout.invalidateLayout()
    }

    func itemAtIndexPath(_ indexPath: IndexPath) -> ChatItem {
        return messages[indexPath.item]
    }

    private var lastWidth: CGFloat?

    override func layoutSubviews() {
        defer { super.layoutSubviews() }

        let currentWidth = bounds.width
        guard lastWidth != currentWidth else { return }
        lastWidth = currentWidth
        let context = ChatCollectionViewLayout.InvalidationContext()
        context.invalidateWidth = true
        layout.invalidateLayout(with: context)
    }
}

extension ChatCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = messages.count
        return count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = itemAtIndexPath(indexPath)
        let reuseIdentifier = type(of: item).defaultReuseIdentifier
        let cell = dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ChatCell
        cell.item = item
        return cell
    }
}

extension ChatCollectionView: UICollectionViewDelegate {
}

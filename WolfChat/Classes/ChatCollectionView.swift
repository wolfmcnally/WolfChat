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
    private(set) var items: [ChatItem] = []

    private let layout = ChatCollectionViewLayout()

    var itemLimit: Int?

    var spacing: CGFloat {
        get { return layout.spacing }
        set { layout.spacing = newValue }
    }

    var verticalInsets: UIEdgeInsets {
        get { return layout.verticalInsets }
        set { layout.verticalInsets = newValue }
    }

    func setItems(_ items: [ChatItem]) {
        self.items = items
        reloadData()
    }

    func addItem(_ item: ChatItem) -> UUID {
        let indexPath = IndexPath(item: items.count, section: 0)
        items.append(item)
        if items.count == 1 {
            reloadData()
        } else {
            performBatchUpdates( {
                self.insertItems(at: [indexPath])
            }, completion: { _ in
                self.scrollToBottom(animated: true)
            } )

            enforceItemLimit()
        }
        return item.id
    }

    func enforceItemLimit() {
        guard let itemLimit = itemLimit, items.count > itemLimit else { return }
        removeItem(at: IndexPath(item: 0, section: 0))
    }

    func removeItem(id: UUID) {
        let index = items.index(where: { $0.id == id })!
        let indexPath = IndexPath(item: index, section: 0)
        removeItem(at: indexPath)
    }

    func removeItem(at indexPath: IndexPath) {
        self.items.remove(at: indexPath.item)
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
        return items[indexPath.item]
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
        let count = items.count
        return count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = itemAtIndexPath(indexPath)
        let reuseIdentifier = type(of: item).identifier
        let cell = dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ChatCell
        cell.item = item
        return cell
    }
}

extension ChatCollectionView: UICollectionViewDelegate {
}

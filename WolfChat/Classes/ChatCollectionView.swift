//
//  ChatCollectionView.swift
//  WolfChat
//
//  Created by Wolf McNally on 3/22/18.
//

import WolfCore
import UIKit

class ChatCollectionView: CollectionView {
    var messages: [ChatItem] = []

    private lazy var layout = ChatCollectionViewLayout()

    var margins: UIEdgeInsets {
        get { return layout.margins }
        set { layout.margins = newValue }
    }

    func addItem(_ item: ChatItem, animated: Bool) -> IndexPath {
        let indexPath = IndexPath(item: messages.count, section: 0)
        messages.append(item)
        if messages.count == 1 {
            reloadData()
        } else {
            insertItems(at: [indexPath])
        }
        return indexPath
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
        layout.invalidateLayout()
    }

    func itemAtIndexPath(_ indexPath: IndexPath) -> ChatItem {
        return messages[indexPath.item]
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
        item.setupCell(cell)
        cell.item = item
        return cell
    }
}

extension ChatCollectionView: UICollectionViewDelegate {
}

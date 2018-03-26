//
//  ChatCollectionView.swift
//  WolfChat
//
//  Created by Wolf McNally on 3/22/18.
//

import WolfCore
import UIKit

class ChatCollectionView: CollectionView {
    var messages: [ChatMessage] = []

    private lazy var layout = ChatCollectionViewLayout()

    var margins: UIEdgeInsets {
        get { return layout.margins }
        set { layout.margins = newValue }
    }

    func addMessage(_ message: ChatMessage, animated: Bool) {
        let indexPath = IndexPath(item: messages.count, section: 0)
        messages.append(message)
        if messages.count == 1 {
            reloadData()
        } else {
            insertItems(at: [indexPath])
        }
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

    func messageAtIndexPath(_ indexPath: IndexPath) -> ChatMessage {
        return messages[indexPath.item]
    }
}

extension ChatCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = messages.count
        return count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let message = messageAtIndexPath(indexPath)
        let cell = dequeueReusableCell(withReuseIdentifier: type(of: message).reuseIdentifier, for: indexPath) as! ChatCell
        message.setupCell(cell)
        cell.message = message
        return cell
    }
}

extension ChatCollectionView: UICollectionViewDelegate {
}

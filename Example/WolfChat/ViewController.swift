//
//  ViewController.swift
//  WolfChat
//
//  Created by wolfmcnally on 03/22/2018.
//  Copyright (c) 2018 wolfmcnally. All rights reserved.
//

import UIKit
import WolfCore
import WolfChat

class ViewController: UIViewController {
    @IBOutlet weak var chatView: ChatView!

    override func viewDidLoad() {
        super.viewDidLoad()

        chatView.register(messageClass: ChatPlaceholderItem.self)
        chatView.register(messageClass: ChatTextItem.self)
        chatView.margins = UIEdgeInsets(all: 10)
    }

    var itemQueue = Queue<ChatItem>()

    private lazy var sentFrameStyle = ChatFrameStyle(fillColor: UIColor(string: "#3FACFD"), shape: .bubble(18, .right))
    private lazy var receivedFrameStyle = ChatFrameStyle(fillColor: UIColor(string: "#E5E5EA"), shape: .bubble(18, .left))

    private lazy var messageTextInsets = UIEdgeInsets(horizontal: 8, vertical: 4)
    let widthFrac: CGFrac = 0.7

    private lazy var sentItemStyle = ChatTextItemStyle(textInsets: messageTextInsets, widthFrac: widthFrac, frameStyle: sentFrameStyle)
    private lazy var receivedItemStyle = ChatTextItemStyle(textInsets: messageTextInsets, widthFrac: widthFrac, frameStyle: receivedFrameStyle)

    private lazy var messageFont = UIFont.systemFont(ofSize: 15)
//    private lazy var messageFont = UIFont.systemFont(ofSize: 24)

    private lazy var sentTextAttributes: StringAttributes = [
        .font : messageFont,
        .foregroundColor: UIColor.white
    ]

    private lazy var receivedTextAttributes: StringAttributes = [
        .font : messageFont,
        .foregroundColor: UIColor.black
    ]

    private func makeSentItem(text: String) -> ChatTextItem {
        let t = text§
        t.setAttributes(sentTextAttributes)
        var item = ChatTextItem(text: t, style: sentItemStyle)
        item.alignment = .right
        return item
    }

    private func makeReceivedItem(text: String) -> ChatTextItem {
        let t = text§
        t.setAttributes(receivedTextAttributes)
        var item = ChatTextItem(text: t, style: receivedItemStyle)
        item.alignment = .left
        return item
    }

    private func addPlaceholderItem(alignment: ChatItemAlignment) {
        var item = ChatPlaceholderItem()
        item.alignment = alignment
        itemQueue.enqueue(item)
    }

    private func addSentTextItem() {
        let sentText = Lorem.sentences(2)
        let sentItem = makeSentItem(text: sentText)
        itemQueue.enqueue(sentItem)
    }

    private func addReceivedTextItem() {
        let receivedText = Lorem.sentences(2)
        let receivedItem = makeReceivedItem(text: receivedText)
        itemQueue.enqueue(receivedItem)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        addPlaceholderItem(alignment: .right)
        addPlaceholderItem(alignment: .left)
        addPlaceholderItem(alignment: .center)
        addPlaceholderItem(alignment: .right)

        addSentTextItem()
        addReceivedTextItem()
        addSentTextItem()
        addReceivedTextItem()
        addSentTextItem()
        addReceivedTextItem()

        dispatchOnMain(afterDelay: 0.5) {
            self.addNextItem()
        }
    }

    private func addNextItem() {
        guard let item = itemQueue.dequeue() else { return }
        let indexPath = chatView.addItem(item, animated: true)
        chatView.scrollToItem(at: indexPath, at: .centeredVertically, animated: true)

        dispatchOnMain(afterDelay: 0.5) {
            self.addNextItem()
        }
    }
}

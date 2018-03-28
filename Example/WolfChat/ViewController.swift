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

        chatView.inputBarTopView = inputBarTopView
        chatView.inputBarLeftView = inputBarLeftView
        chatView.inputBarRightView = inputBarRightView

        chatView.shouldReturn = { [unowned self] _ in
            self.send()
            return false
        }

        chatView.onSendButton = { [unowned self] in
            self.send()
        }

        needsPostItem = Asynchronizer(delay: 0.5) { [unowned self] in
            self.postItemIfNeeded()
        }
    }

    private func setNeedsPostItem() {
        needsPostItem.setNeedsSync()
    }

    private var itemQueue = Queue<ChatItem>()
    private var needsPostItem: Asynchronizer!

    private func addItem(_ item: ChatItem) {
        itemQueue.enqueue(item)
        setNeedsPostItem()
    }

    private func postItem(_ item: ChatItem) {
        chatView.addItem(item)
    }

    private func postItemIfNeeded() {
        needsPostItem.cancel()
        guard let item = itemQueue.dequeue() else { return }
        postItem(item)

        if !itemQueue.isEmpty {
            setNeedsPostItem()
        }
    }

    private let isDebug = false

    private lazy var inputBarTopView = PlaceholderView(title: "Top") • { 🍒 in
        🍒.constrainHeight(to: 20)
        🍒.backgroundColor = debugColor(when: isDebug, debug: .red)
    }

    private lazy var inputBarLeftView = PlaceholderView(title: "Left") • { 🍒 in
        🍒.constrainWidth(to: 40)
        🍒.backgroundColor = debugColor(when: isDebug, debug: .green)
    }

    private lazy var inputBarRightView = PlaceholderView(title: "Right") • { 🍒 in
        🍒.constrainWidth(to: 40)
        🍒.backgroundColor = debugColor(when: isDebug, debug: .blue)
    }

    private lazy var sentFrameStyle = ChatFrameStyle(fillColor: UIColor(string: "#3FACFD"), shape: .bubble(cornerRadius: 18, tailCorner: .right))
    private lazy var receivedFrameStyle = ChatFrameStyle(fillColor: UIColor(string: "#E5E5EA"), shape: .bubble(cornerRadius: 18, tailCorner: .left))

    private lazy var messageTextInsets = UIEdgeInsets(horizontal: 8, vertical: 4)
    let widthFrac: CGFrac = 0.7

    private lazy var sentItemStyle = ChatTextItemStyle(textInsets: messageTextInsets, widthFrac: widthFrac, frameStyle: sentFrameStyle)
    private lazy var receivedItemStyle = ChatTextItemStyle(textInsets: messageTextInsets, widthFrac: widthFrac, frameStyle: receivedFrameStyle)

    private lazy var messageFont = UIFont.systemFont(ofSize: 15)

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
        addItem(item)
    }

    private func addSentTextItem(text: String? = nil) {
        let theText = text ?? Lorem.sentences(2, emojisFrac: 0.1)
        let item = makeSentItem(text: theText)
        addItem(item)
    }

    private func addReceivedTextItem() {
        let text = Lorem.sentences(2, emojisFrac: 0.1)
        let item = makeReceivedItem(text: text)
        addItem(item)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        chatView.beginEditing()

        addPlaceholderItem(alignment: .right)
        addPlaceholderItem(alignment: .left)
        addPlaceholderItem(alignment: .center)
        addPlaceholderItem(alignment: .right)

        for _ in 0 ..< 4 {
            addSentTextItem()
            addReceivedTextItem()
        }
    }

    private func send() {
        let item = makeSentItem(text: chatView.text)
        postItem(item)
        chatView.removeText()
        dispatchOnMain(afterDelay: 1.0) {
            self.addReceivedTextItem()
        }
    }
}

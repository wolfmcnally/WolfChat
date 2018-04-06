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

        chatView.setInputBarTopView(inputBarTopView, animated: false)
        chatView.setInputBarLeftView(inputBarLeftView, animated: false)
        chatView.setInputBarRightView(inputBarRightView, animated: false)

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

    private func addPlaceholderItem(alignment: ChatItemAlignment) {
        var item = ChatPlaceholderItem()
        item.alignment = alignment
        addItem(item)
    }

    private func addSentTextItem(text: String? = nil) {
        let theText = text ?? Lorem.sentences(2, emojisFrac: 0.1)
        let item = AppChatTextItem(sender: "me", text: theText)
        addItem(item)
    }

    private func addReceivedTextItem() {
        let text = Lorem.sentences(2, emojisFrac: 0.1)
        let item = AppChatTextItem(sender: "you", text: text)
        addItem(item)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        chatView.beginEditing()

//        addPlaceholderItem(alignment: .right)
//        addPlaceholderItem(alignment: .left)
//        addPlaceholderItem(alignment: .center)
//        addPlaceholderItem(alignment: .right)
//
        for _ in 0 ..< 4 {
            addSentTextItem()
            addReceivedTextItem()
        }
//
//        addSentTextItem(text: "Hello, world!")
    }

    private func send() {
        let item = AppChatTextItem(sender: "me", text: chatView.text)
        postItem(item)
        chatView.removeText()
        dispatchOnMain(afterDelay: 1.0) {
            self.addReceivedTextItem()
        }
    }
}

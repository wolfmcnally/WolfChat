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

//        let bordersTestView = BordersTestView()
//        view => [
//            bordersTestView
//        ]
//        bordersTestView.constrainCenterToCenter()
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

    private lazy var sentFrameOrnaments = CornerOrnaments(cornerRadius: 18) •• { 🍒 in
        🍒.bottomRight = .bubbleTail(18)
    }

    private lazy var receivedFrameOrnaments = CornerOrnaments(cornerRadius: 18) •• { 🍒 in
        🍒.bottomLeft = .bubbleTail(18)
    }

    private lazy var sentBorder = OrnamentedCornersBorder() •• { 🍒 in
        🍒.ornaments = CornerOrnaments(cornerRadius: 18)
        🍒.ornaments.bottomRight = .bubbleTail(18)
        🍒.fillColor = try! UIColor(string: "#3FACFD")
        🍒.strokeColor = nil
    }

    private lazy var receivedBorder = OrnamentedCornersBorder() •• { 🍒 in
        🍒.ornaments = CornerOrnaments(cornerRadius: 18)
        🍒.ornaments.bottomLeft = .bubbleTail(18)
        🍒.fillColor = try! UIColor(string: "#E5E5EA")
        🍒.strokeColor = nil
    }

    private lazy var messageTextInsets = UIEdgeInsets(horizontal: 8, vertical: 4)
    let widthFrac: CGFrac = 0.7

    private lazy var sentItemStyle = ChatTextItemStyle(textInsets: messageTextInsets, widthFrac: widthFrac, border: sentBorder)
    private lazy var receivedItemStyle = ChatTextItemStyle(textInsets: messageTextInsets, widthFrac: widthFrac, border: receivedBorder)

    private lazy var messageFont = UIFont.systemFont(ofSize: 15)

    private lazy var sentTextAttributes: StringAttributes = [
        .font : messageFont,
        .foregroundColor: UIColor.white
    ]

    private lazy var receivedTextAttributes: StringAttributes = [
        .font : messageFont,
        .foregroundColor: UIColor.black
    ]

    private func makeAvatarImage(color: UIColor) -> UIImage {
        let size = CGSize(width: 30, height: 30)
        return newImage(withSize: size) { context in
            context.setFillColor(color.cgColor)
            context.fillEllipse(in: size.bounds)
        }
    }

    private lazy var sentAvatarImage = makeAvatarImage(color: UIColor.red.darkened(by: 0.1))
    private lazy var receivedAvatarImage = makeAvatarImage(color: UIColor.green.darkened(by: 0.3))

    private func makeAvatarView(with image: UIImage) -> UIView {
        return ImageView(image: image)
    }

    private func makeSentAvatarView() -> UIView {
        return makeAvatarView(with: sentAvatarImage)
    }

    private func makeReceivedAvatarView() -> UIView {
        return makeAvatarView(with: receivedAvatarImage)
    }

    private func makeSentItem(text: String) -> ChatTextItem {
        let t = text§
        t.setAttributes(sentTextAttributes)
        let avatarView = makeSentAvatarView()
        avatarView.constrainSize(to: CGSize(width: 30, height: 30))
        let item = ChatTextItem(text: t, style: sentItemStyle, alignment: .right, avatarView: avatarView)
        return item
    }

    private func makeReceivedItem(text: String) -> ChatTextItem {
        let t = text§
        t.setAttributes(receivedTextAttributes)
        let avatarView = makeReceivedAvatarView()
        avatarView.constrainSize(to: CGSize(width: 30, height: 30))
        let item = ChatTextItem(text: t, style: receivedItemStyle, alignment: .left, avatarView: avatarView)
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
        let item = makeSentItem(text: chatView.text)
        postItem(item)
        chatView.removeText()
        dispatchOnMain(afterDelay: 1.0) {
            self.addReceivedTextItem()
        }
    }
}

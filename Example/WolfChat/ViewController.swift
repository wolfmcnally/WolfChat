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

        chatView.register(messageClass: ChatPlaceholderMessage.self)
        chatView.register(messageClass: ChatTextMessage.self)
        chatView.margins = UIEdgeInsets(all: 10)
    }

    var messageQueue = Queue<ChatMessage>()

    private lazy var sentFrameStyle = ChatFrameStyle(fillColor: UIColor(string: "#3FACFD"), shape: .bubble(18, .right))
    private lazy var receivedFrameStyle = ChatFrameStyle(fillColor: UIColor(string: "#E5E5EA"), shape: .bubble(18, .left))

    private lazy var messageTextInsets = UIEdgeInsets(horizontal: 8, vertical: 4)
    let widthFrac: CGFrac = 0.7

    private lazy var sentMessageStyle = ChatTextMessageStyle(textInsets: messageTextInsets, widthFrac: widthFrac, frameStyle: sentFrameStyle)
    private lazy var receivedMessageStyle = ChatTextMessageStyle(textInsets: messageTextInsets, widthFrac: widthFrac, frameStyle: receivedFrameStyle)

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

    private func makeSentMessage(text: String) -> ChatTextMessage {
        let t = text§
        t.setAttributes(sentTextAttributes)
        var message = ChatTextMessage(text: t, style: sentMessageStyle)
        message.alignment = .right
        return message
    }

    private func makeReceivedMessage(text: String) -> ChatTextMessage {
        let t = text§
        t.setAttributes(receivedTextAttributes)
        var message = ChatTextMessage(text: t, style: receivedMessageStyle)
        message.alignment = .left
        return message
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        var placeholderMessage = ChatPlaceholderMessage()
        messageQueue.enqueue(placeholderMessage)
        placeholderMessage.alignment = .left
        messageQueue.enqueue(placeholderMessage)
        placeholderMessage.alignment = .center
        messageQueue.enqueue(placeholderMessage)
        placeholderMessage.alignment = .right
        messageQueue.enqueue(placeholderMessage)

        let sentText = Lorem.sentences(2)
        let sentMessage = makeSentMessage(text: sentText)
        messageQueue.enqueue(sentMessage)

        let receivedText = Lorem.sentences(2)
        let receivedMessage = makeReceivedMessage(text: receivedText)
        messageQueue.enqueue(receivedMessage)

        dispatchOnMain(afterDelay: 0.5) {
            self.dispatchNextMessage()
        }
    }

    private func dispatchNextMessage() {
        guard let message = messageQueue.dequeue() else { return }
        chatView.addMessage(message, animated: true)
        dispatchOnMain(afterDelay: 0.1) {
            self.dispatchNextMessage()
        }
    }
}

//
//  AppChatTextItem.swift
//  WolfChat_Example
//
//  Created by Wolf McNally on 4/6/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import WolfChat
import WolfCore

class AppChatTextItem: ChatTextItem {
    private typealias `Self` = AppChatTextItem

    static let messageFont = UIFont.systemFont(ofSize: 15)

    static func makeAvatarView(color: UIColor) -> UIView {
        let size = CGSize(width: 30, height: 30)
        let image = newImage(withSize: size) { context in
            context.setFillColor(color.cgColor)
            context.fillEllipse(in: size.bounds)
        }
        let view = ImageView(image: image)
        view.constrainSize(to: size)
        return view
    }

    static let textInsets = UIEdgeInsets(horizontal: 8, vertical: 4)

    static let widthFrac: CGFrac = 0.7

    private static let sentItemStyle = ChatTextItemStyle() • { 🍒 in
        🍒.alignment = .right
        🍒.widthFrac = Self.widthFrac

        🍒.border = OrnamentedCornersBorder() •• { 🍋 in
            🍋.ornaments = CornerOrnaments(cornerRadius: 18)
            🍋.ornaments.bottomRight = .bubbleTail(18)
            🍋.fillColor = try! UIColor(string: "#3FACFD")
            🍋.strokeColor = nil
        }

        🍒.textAttributes = [
            .font : Self.messageFont,
            .foregroundColor: UIColor.white
        ]

        🍒.textInsets = Self.textInsets

        🍒.makeAvatarView = { _ in
            return Self.makeAvatarView(color: UIColor.red.darkened(by: 0.1))
        }
    }

    private static let receivedItemStyle = ChatTextItemStyle() • { 🍒 in
        🍒.alignment = .left
        🍒.widthFrac = Self.widthFrac

        🍒.border = OrnamentedCornersBorder() •• { 🍋 in
            🍋.ornaments = CornerOrnaments(cornerRadius: 18)
            🍋.ornaments.bottomLeft = .bubbleTail(18)
            🍋.fillColor = try! UIColor(string: "#E5E5EA")
            🍋.strokeColor = nil
        }

        🍒.textAttributes = [
            .font : Self.messageFont,
            .foregroundColor: UIColor.black
        ]

        🍒.textInsets = Self.textInsets

        🍒.makeAvatarView = { _ in
            return Self.makeAvatarView(color: UIColor.green.darkened(by: 0.3))
        }
    }

    class override func styleForSender(_ sender: String) -> ChatTextItemStyle {
        switch sender {
        case "me":
            return sentItemStyle
        case "you":
            return receivedItemStyle
        default:
            preconditionFailure()
        }
    }

    init(sender: String, id: UUID = UUID(), date: Date = Date(), text: String) {
        let style = Self.styleForSender(sender)
        super.init(date: date, id: id, sender: sender, style: style, text: text)
    }

    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }
}

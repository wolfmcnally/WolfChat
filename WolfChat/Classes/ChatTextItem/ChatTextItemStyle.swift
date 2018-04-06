//
//  ChatTextItemStyle.swift
//  WolfChat
//
//  Created by Wolf McNally on 4/1/18.
//

import WolfCore

/// Specifies the visual style of a `ChatTextItem`.
open class ChatTextItemStyle {
    public var alignment: ChatItemAlignment = .right
    public var widthFrac: CGFrac = 0
    public var border: Border = RectBorder()
    public var textAttributes: StringAttributes = [:]
    public var textInsets: UIEdgeInsets = .zero
    public var avatarSpacing: CGFloat = 10
    public var makeAvatarView: ((String) -> UIView)? = nil

    public init() { }
}

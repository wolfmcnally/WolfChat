//
//  ChatTextItemStyle.swift
//  WolfChat
//
//  Created by Wolf McNally on 4/1/18.
//

import WolfCore

/// Specifies the visual style of a `ChatTextItem`.
public struct ChatTextItemStyle {
    public let textInsets: UIEdgeInsets
    public let widthFrac: CGFrac
    public let border: Border
    public let avatarSpacing: CGFloat

    public var shapeInsets: UIEdgeInsets {
        return border.insets
    }

    public init(textInsets: UIEdgeInsets, widthFrac: CGFrac, border: Border, avatarSpacing: CGFloat = 0) {
        self.textInsets = textInsets
        self.widthFrac = widthFrac
        self.border = border
        self.avatarSpacing = avatarSpacing
    }
}

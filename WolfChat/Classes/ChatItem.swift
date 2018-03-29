//
//  ChatItem.swift
//  WolfChat
//
//  Created by Wolf McNally on 3/22/18.
//

public protocol ChatItem {
    static var defaultReuseIdentifier: String { get }
    static var cellClass: AnyClass { get }
    var id: UUID { get }
    func sizeThatFits(_ size: CGSize) -> CGSize
    var alignment: ChatItemAlignment { get }
}


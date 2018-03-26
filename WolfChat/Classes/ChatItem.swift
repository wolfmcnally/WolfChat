//
//  ChatItem.swift
//  WolfChat
//
//  Created by Wolf McNally on 3/22/18.
//

public protocol ChatItem {
    static var defaultReuseIdentifier: String { get }
    static var cellClass: AnyClass { get }
    func setupCell(_ cell: ChatCell)
    func cellSizeForWidth(_ width: CGFloat) -> CGSize
    var alignment: ChatItemAlignment { get }
}

extension ChatItem {
    public func setupCell(_ cell: ChatCell) { }
}

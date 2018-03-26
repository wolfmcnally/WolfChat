//
//  ChatMessage.swift
//  WolfChat
//
//  Created by Wolf McNally on 3/22/18.
//

public protocol ChatMessage {
    static var reuseIdentifier: String { get }
    static var cellClass: AnyClass { get }
    func setupCell(_ cell: ChatCell)
    func cellSizeForWidth(_ width: CGFloat) -> CGSize
    var alignment: ChatMessageAlignment { get }
}

extension ChatMessage {
    public func setupCell(_ cell: ChatCell) { }
}

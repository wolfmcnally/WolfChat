//
//  ChatItem.swift
//  WolfChat
//
//  Created by Wolf McNally on 3/22/18.
//

/// Represents an item that appears in the chat view.
/// Contains the model object(s) for the item.
/// Also knows how to measure for the collection cell that will be created for it.
/// Frequently contains the views that will be part of the collection view cell, as this
/// way they can be measured correctly using layout techniques (autolayout or similar).
public protocol ChatItem {
    static var defaultReuseIdentifier: String { get }
    static var cellClass: AnyClass { get }
    var id: UUID { get }
    func sizeThatFits(_ size: CGSize) -> CGSize
    var alignment: ChatItemAlignment { get }
    var horizontalInsets: UIEdgeInsets { get }
}

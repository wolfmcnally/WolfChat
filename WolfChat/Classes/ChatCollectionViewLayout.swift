//
//  ChatCollectionViewLayout.swift
//  WolfChat
//
//  Created by Wolf McNally on 3/22/18.
//

import WolfCore
import UIKit

extension LogGroup {
    public static let chatCollectionViewInvalidation = LogGroup("chatCollectionViewInvalidation")
}

extension UICollectionViewLayoutInvalidationContext {
    override open var description: String {
        return "<\(super.description) everything: \(invalidateEverything), dataSourceCounts: \(invalidateDataSourceCounts), indexPaths: \(invalidatedItemIndexPaths†), previousInteractiveIndexPaths: \(previousIndexPathsForInteractivelyMovingItems†), targetInteractiveIndexPaths: \(targetIndexPathsForInteractivelyMovingItems†), contentSizeAdjustment: \(contentSizeAdjustment), contentOffsetAdjustment: \(contentOffsetAdjustment), interactiveTarget: \(interactiveMovementTarget)>"
    }
}

/// The strategy for laying out the `ChatCell`s in a `ChatCollectionView`.
class ChatCollectionViewLayout: UICollectionViewLayout {
    class InvalidationContext: UICollectionViewLayoutInvalidationContext {
        var invalidateWidth: Bool = false
        var invalidateSpacing: Bool = false
        var invalidateMargins: Bool = false
    }

    var spacing: CGFloat = 10 {
        didSet {
            let context = ChatCollectionViewLayout.InvalidationContext()
            context.invalidateSpacing = true
            invalidateLayout(with: context)
        }
    }

    var verticalInsets = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0) {
        didSet {
            let context = ChatCollectionViewLayout.InvalidationContext()
            context.invalidateMargins = true
            invalidateLayout(with: context)
        }
    }

    private var cache: [UICollectionViewLayoutAttributes?] = []
    private var contentSize: CGSize?

    private var contentWidth: CGFloat {
        return chatCollectionView.bounds.width
    }

    private var chatCollectionView: ChatCollectionView {
        return collectionView as! ChatCollectionView
    }

    private var messages: [ChatItem] {
        return chatCollectionView.messages
    }

    private func invalidateAll() {
        cache.removeAll()
        contentSize = nil
    }

    override func invalidateLayout(with context: UICollectionViewLayoutInvalidationContext) {
        super.invalidateLayout(with: context)
        if context.invalidateEverything {
            // happens on reloadData()
            logTrace("invalidateEverything", group: .chatCollectionViewInvalidation)
            invalidateAll()
        } else if context.invalidateDataSourceCounts {
            // happens when new item appended
            logTrace("invalidateDataSourceCounts", group: .chatCollectionViewInvalidation)
            contentSize = nil
        } else if let invalidatedItemIndexPaths = context.invalidatedItemIndexPaths {
            // happens when items are deleted
            logTrace("invalidatedItemIndexPaths: \(invalidatedItemIndexPaths)", group: .chatCollectionViewInvalidation)

            let lowestIndex = invalidatedItemIndexPaths.reduce(Int.max) { (lowestSoFar, indexPath) -> Int in
                return min(lowestSoFar, indexPath.item)
            }
            for index in lowestIndex ..< cache.count {
                cache[index] = nil
            }
            contentSize = nil
        } else if let context = context as? InvalidationContext {
            if context.invalidateWidth {
                // happens when the device rotates
                logTrace("invalidateWidth", group: .chatCollectionViewInvalidation)
                invalidateAll()
            } else if context.invalidateSpacing {
                // happens during setup
                logTrace("invalidateSpacing", group: .chatCollectionViewInvalidation)
                invalidateAll()
            } else if context.invalidateMargins {
                // happens during setup
                logTrace("invalidateMargins", group: .chatCollectionViewInvalidation)
                invalidateAll()
            } else {
                // something else happened
                preconditionFailure("Unrecognized custom invalidation context.")
            }
        } else {
            // something else happened
            logWarning("Unrecognized invalidation context.", group: .chatCollectionViewInvalidation)
        }
    }

    override var collectionViewContentSize: CGSize {
        guard contentSize == nil else { return contentSize! }
        guard messages.count > 0 else { return .zero }

        let lastIndexPath = IndexPath(item: messages.count - 1, section: 0)
        let lastAttributes = layoutAttributesForItem(at: lastIndexPath)!
        let width = contentWidth
        let height = lastAttributes.frame.maxY + verticalInsets.bottom
        contentSize = CGSize(width: width, height: height)
        return contentSize!
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var intersectingAttributes = [UICollectionViewLayoutAttributes]()
        for item in 0 ..< messages.count {
            let indexPath = IndexPath(item: item, section: 0)
            let attributes = layoutAttributesForItem(at: indexPath)!
            if attributes.frame.intersects(rect) {
                intersectingAttributes.append(attributes)
            }
        }
        return intersectingAttributes
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes: UICollectionViewLayoutAttributes

        if cache.count > indexPath.item, let cachedAttributes = cache[indexPath.item] {
            attributes = cachedAttributes
        } else {
            //print("generating: \(indexPath)")
            let maxY: CGFloat
            if let previousIndexPath = indexPathBefore(indexPath) {
                let previousAttributes = layoutAttributesForItem(at: previousIndexPath)!
                maxY = previousAttributes.frame.maxY + spacing
            } else {
                maxY = verticalInsets.top
            }

            let item = itemAtIndexPath(indexPath)
            let y = maxY
            let maxWidth = contentWidth - item.horizontalInsets.horizontal
            let preferredSize = item.sizeThatFits(CGSize(width: maxWidth, height: .greatestFiniteMagnitude))
            let width = min(preferredSize.width, maxWidth)
            let size = CGSize(width: width, height: preferredSize.height)
            let x: CGFloat
            switch item.alignment {
            case .left:
                x = item.horizontalInsets.left
            case .center:
                x = (maxWidth - width) / 2
            case .right:
                x = contentWidth - width - item.horizontalInsets.right
            }
            let origin = CGPoint(x: x, y: y)

            let newAttributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            let frame = CGRect(origin: origin, size: size)
            newAttributes.frame = frame
            newAttributes.bounds = size.bounds

            while cache.count <= indexPath.item {
                cache.append(nil)
            }
            cache[indexPath.item] = newAttributes

            attributes = newAttributes
        }

        return attributes
    }

    private func indexPathBefore(_ indexPath: IndexPath) -> IndexPath? {
        guard indexPath.item > 0 else { return nil }
        return IndexPath(item: indexPath.item - 1, section: indexPath.section)
    }

    private func itemAtIndexPath(_ indexPath: IndexPath) -> ChatItem {
        return chatCollectionView.itemAtIndexPath(indexPath)
    }
}

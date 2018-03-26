//
//  ChatCollectionViewLayout.swift
//  WolfChat
//
//  Created by Wolf McNally on 3/22/18.
//

import WolfCore
import UIKit

extension UICollectionViewLayoutInvalidationContext {
    override open var description: String {
        return "<\(super.description) everything: \(invalidateEverything), dataSourceCounts: \(invalidateDataSourceCounts), indexPaths: \(invalidatedItemIndexPaths†), previousInteractiveIndexPaths: \(previousIndexPathsForInteractivelyMovingItems†), targetInteractiveIndexPaths: \(targetIndexPathsForInteractivelyMovingItems†), contentSizeAdjustment: \(contentSizeAdjustment), contentOffsetAdjustment: \(contentOffsetAdjustment), interactiveTarget: \(interactiveMovementTarget)>"
    }
}

class ChatCollectionViewLayout: UICollectionViewLayout {
    var spacing: CGFloat = 10 {
        didSet { invalidateLayout() }
    }

    var margins: UIEdgeInsets = .zero {
        didSet { invalidateLayout() }
    }

    private var cache: [IndexPath : UICollectionViewLayoutAttributes] = [:]
    private var contentSize: CGSize?

    private var effectiveBoundsSize: CGSize?
    private var boundsSize: CGSize {
        if let effectiveBoundsSize = effectiveBoundsSize {
            return effectiveBoundsSize
        }

        return chatCollectionView.bounds.size
    }

    private var contentWidth: CGFloat {
        return boundsSize.width
    }

    private var chatCollectionView: ChatCollectionView {
        return collectionView as! ChatCollectionView
    }

    private var messages: [ChatMessage] {
        return chatCollectionView.messages
    }

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        let newSize = newBounds.size
        if effectiveBoundsSize != newSize {
            effectiveBoundsSize = newSize
            return true
        }
        return false
    }

    override func invalidateLayout(with context: UICollectionViewLayoutInvalidationContext) {
        super.invalidateLayout(with: context)
        if context.invalidateEverything {
            cache.removeAll()
            contentSize = nil
        } else if context.invalidateDataSourceCounts {
            contentSize = nil
        } else {
            //print(context)
            cache.removeAll()
            contentSize = nil
            //preconditionFailure()
        }
    }

    override var collectionViewContentSize: CGSize {
        guard contentSize == nil else { return contentSize! }
        guard messages.count > 0 else { return .zero }

        let lastIndexPath = IndexPath(item: messages.count - 1, section: 0)
        let lastAttributes = layoutAttributesForItem(at: lastIndexPath)!
        let width = contentWidth
        let height = lastAttributes.frame.maxY + margins.bottom
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

        if let cachedAttributes = cache[indexPath] {
            attributes = cachedAttributes
        } else {
            //print("generating: \(indexPath)")
            let maxY: CGFloat
            if let previousIndexPath = indexPathBefore(indexPath) {
                let previousAttributes = layoutAttributesForItem(at: previousIndexPath)!
                maxY = previousAttributes.frame.maxY + spacing
            } else {
                maxY = margins.top
            }

            let message = messageAtIndexPath(indexPath)
            let y = maxY
            let maxWidth = contentWidth
            let preferredSize = message.cellSizeForWidth(maxWidth)
            let width = min(preferredSize.width, maxWidth)
            let size = CGSize(width: width, height: preferredSize.height)
            let x: CGFloat
            switch message.alignment {
            case .left:
                x = margins.left
            case .center:
                x = (maxWidth - width) / 2
            case .right:
                x = maxWidth - width - margins.right
            }
            let origin = CGPoint(x: x, y: y)

            let newAttributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            let frame = CGRect(origin: origin, size: size)
            newAttributes.frame = frame
            newAttributes.bounds = size.bounds

            cache[indexPath] = newAttributes

            attributes = newAttributes
        }

        return attributes
    }

    private func indexPathBefore(_ indexPath: IndexPath) -> IndexPath? {
        guard indexPath.item > 0 else { return nil }
        return IndexPath(item: indexPath.item - 1, section: indexPath.section)
    }

    private func messageAtIndexPath(_ indexPath: IndexPath) -> ChatMessage {
        return chatCollectionView.messageAtIndexPath(indexPath)
    }
}

//
//  ChatTextCell.swift
//  WolfChat
//
//  Created by Wolf McNally on 4/1/18.
//

import WolfCore

/// A fully-featured `ChatCell` used for representing text in a chat.
open class ChatTextCell: ChatCell {
    open override var reuseIdentifier: String? {
        return ChatTextItem.defaultReuseIdentifier
    }

    private var textItem: ChatTextItem {
        return item as! ChatTextItem
    }

    private var label: Label {
        return textItem.label
    }

    private var avatarView: UIView? {
        return textItem.avatarView
    }

    private var textInsets: UIEdgeInsets {
        return textItem.style.textInsets
    }

    private var borderInsets: UIEdgeInsets {
        return textItem.style.border.insets
    }

    open override func prepareForReuse() {
        super.prepareForReuse()
        contentView.removeAllSubviews()
        stackView.removeAllSubviews()
        avatarContainerView.removeAllSubviews()
        textContainerView.removeAllSubviews()
    }

    private lazy var stackView = HorizontalStackView()
    private lazy var avatarContainerView = VerticalStackView()
    private lazy var textContainerView = View()

    open override func syncToItem() {
        super.syncToItem()

        contentView => [
            stackView => [
                textContainerView => [
                    textItem.backgroundView,
                    label
                ]
            ]
        ]

        textItem.backgroundView.constrainFrameToFrame()
        stackView.spacing = textItem.style.avatarSpacing

        if let avatarView = avatarView {
            avatarContainerView => [
                View(), // To bottom-align avatar view
                avatarView
            ]
            switch textItem.alignment {
            case .left:
                stackView.insertArrangedSubview(avatarContainerView, at: 0)
            case .right:
                stackView.addArrangedSubview(avatarContainerView)
            case .center:
                preconditionFailure()
            }
        }

        stackView.constrainFrameToFrame()
        let insets = textInsets + borderInsets
        label.constrainFrameToFrame(insets: CGInsets(edgeInsets: insets))
    }
}

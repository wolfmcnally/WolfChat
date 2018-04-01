//
//  ChatFrameView.swift
//  WolfChat
//
//  Created by Wolf McNally on 3/23/18.
//

import WolfCore

public class ChatFrameView: View {
    public var border: Border {
        didSet { setNeedsDisplay() }
    }

    public init(border: Border) {
        self.border = border
        super.init(frame: .zero)
        contentMode = .redraw
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func draw(_ rect: CGRect) {
        border.draw(in: bounds)
    }
}

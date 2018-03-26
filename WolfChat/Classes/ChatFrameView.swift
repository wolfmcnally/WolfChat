//
//  ChatFrameView.swift
//  WolfChat
//
//  Created by Wolf McNally on 3/23/18.
//

import WolfCore

public enum ChatFrameShape {
    case rectangle
    case rounded(cornerRadius: CGFloat)
    case bubble(cornerRadius: CGFloat, tailCorner: TailCorner)

    public enum TailCorner {
        case left
        case right
    }

    private func effectiveCornerRadius(for frame: CGRect, cornerRadius: CGFloat) -> CGFloat {
        let minDimension = min(frame.width, frame.height)
        return min(cornerRadius, minDimension / 2)
    }

    private func makeRoundedCornersPath(in rect: CGRect, cornerRadius: CGFloat) -> UIBezierPath {
        return UIBezierPath(roundedRect: rect, cornerRadius: effectiveCornerRadius(for: rect, cornerRadius: cornerRadius))
    }

    private func makeBubblePath(in rect: CGRect, cornerRadius: CGFloat, tailCorner: TailCorner) -> UIBezierPath {
        var frame = rect
        var smallRadius = cornerRadius / 2

        let hasLeftTail: Bool
        let hasRightTail: Bool

        switch tailCorner {
        case .left:
            hasLeftTail = true
            hasRightTail = false
        case .right:
            hasLeftTail = false
            hasRightTail = true
        }

        if hasLeftTail {
            frame.setMinXIndependent(frame.minX + smallRadius)
        }
        if hasRightTail {
            frame.setMaxXIndependent(frame.maxX - smallRadius)
        }

        let cornerRadius = effectiveCornerRadius(for: frame, cornerRadius: cornerRadius)
        smallRadius = cornerRadius / 2

        let centerFrame = frame.insetBy(dx: cornerRadius, dy: cornerRadius)

        let path = UIBezierPath()

        let a: CGFloat = 26.2°
        let b: CGFloat = 36°

        do {
            let center = centerFrame.maxXmaxY
            if hasRightTail {
                let center2 = CGPoint(x: center.x + cornerRadius + smallRadius, y: center.y - cornerRadius)
                let center3 = CGPoint(x: center.x + cornerRadius + smallRadius, y: center.y + smallRadius)
                path.addArc(withCenter: center3, radius: smallRadius, startAngle: 180°, endAngle: 90°, clockwise: false)
                path.addArc(withCenter: center2, radius: cornerRadius * 2, startAngle: 90°, endAngle: 90° + a, clockwise: true)
                path.addArc(withCenter: center, radius: cornerRadius, startAngle: 90° - b, endAngle: 90°, clockwise: true)
            } else {
                path.addArc(withCenter: center, radius: cornerRadius, startAngle: 0°, endAngle: 90°, clockwise: true)
            }
        }

        do {
            let center = centerFrame.minXmaxY
            if hasLeftTail {
                let center2 = CGPoint(x: center.x - cornerRadius - smallRadius, y: center.y - cornerRadius)
                let center3 = CGPoint(x: center.x - cornerRadius - smallRadius, y: center.y + smallRadius)
                path.addArc(withCenter: center, radius: cornerRadius, startAngle: 90°, endAngle: 90° + b, clockwise: true)
                path.addArc(withCenter: center2, radius: cornerRadius * 2, startAngle: 90° - a, endAngle: 90°, clockwise: true)
                path.addArc(withCenter: center3, radius: smallRadius, startAngle: 90°, endAngle: 0°, clockwise: false)
            } else {
                path.addArc(withCenter: center, radius: cornerRadius, startAngle: 90°, endAngle: 180°, clockwise: true)
            }
        }

        path.addArc(withCenter: centerFrame.minXminY, radius: cornerRadius, startAngle: 180°, endAngle: 270°, clockwise: true)

        path.addArc(withCenter: centerFrame.maxXminY, radius: cornerRadius, startAngle: 270°, endAngle: 360°, clockwise: true)

        path.close()

        return path
    }

    public func makePath(in rect: CGRect) -> UIBezierPath {
        switch self {
        case .rectangle:
            return UIBezierPath(rect: rect)
        case .rounded(let cornerRadius):
            return makeRoundedCornersPath(in: rect, cornerRadius: cornerRadius)
        case .bubble(let cornerRadius, let tailCorner):
            return makeBubblePath(in: rect, cornerRadius: cornerRadius, tailCorner: tailCorner)
        }
    }

    public var insets: UIEdgeInsets {
        switch self {
        case .rectangle:
            return .zero
        case .rounded(let cornerRadius):
            return UIEdgeInsets(all: sqrt(cornerRadius))
        case .bubble(let cornerRadius, let tailCorner):
            let r = sqrt(cornerRadius)
            let smallRadius = cornerRadius / 2
            var ins = UIEdgeInsets(all: r)
            switch tailCorner {
            case .left:
                ins.left += smallRadius
            case .right:
                ins.right += smallRadius
            }
            return ins
        }
    }
}

public struct ChatFrameStyle {
    public let strokeColor: UIColor?
    public let lineWidth: CGFloat
    public let fillColor: UIColor?
    public let shape: ChatFrameShape?

    public var shapeInsets: UIEdgeInsets {
        return shape?.insets ?? .zero
    }

    public init(strokeColor: UIColor? = nil, lineWidth: CGFloat = 1, fillColor: UIColor? = nil, shape: ChatFrameShape? = nil) {
        self.strokeColor = strokeColor
        self.lineWidth = lineWidth
        self.fillColor = fillColor
        self.shape = shape
    }
}

public class ChatFrameView: View {
    private let style: ChatFrameStyle

    public init(style: ChatFrameStyle) {
        self.style = style
        super.init(frame: .zero)
        contentMode = .redraw
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func draw(_ rect: CGRect) {
        guard let shape = style.shape else { return }

        func drawFill() {
            guard let fillColor = style.fillColor else { return }
            let path = shape.makePath(in: bounds)
            fillColor.setFill()
            path.fill()
        }

        func drawStroke() {
            guard let strokeColor = style.strokeColor else { return }
            let halfLineWidth = style.lineWidth / 2
            let strokeBounds = bounds.insetBy(dx: halfLineWidth, dy: halfLineWidth)
            let path = shape.makePath(in: strokeBounds)
            strokeColor.setStroke()
            path.lineWidth = style.lineWidth
            path.stroke()
        }

        drawFill()
        drawStroke()
    }
}

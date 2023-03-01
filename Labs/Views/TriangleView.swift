import UIKit

class TriangleView : UIView {
    
    private let context = UIBezierPath()
    private let shapeLayer = CAShapeLayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        drawTriangle()
        self.layer.addSublayer(shapeLayer)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    private func drawTriangle() {
        context.move(to: CGPoint(x: frame.minX, y: frame.maxY))
        context.addLine(to: CGPoint(x: frame.maxX, y: frame.maxY))
        context.addLine(to: CGPoint(x: frame.maxX, y: frame.minY + 350))
        context.addLine(to: CGPoint(x: frame.minX, y: frame.maxY))
        
        shapeLayer.path = context.cgPath
        shapeLayer.fillColor = UIColor(hex: 0x760208).cgColor
    }
    
    func changeTryangleColor(_ color: CGColor) {
        shapeLayer.fillColor = color
    }
}

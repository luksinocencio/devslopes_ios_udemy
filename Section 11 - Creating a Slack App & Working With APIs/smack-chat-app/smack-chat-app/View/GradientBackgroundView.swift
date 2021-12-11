import Foundation

@IBDesignable
class GradientBackgroundView: UIView {
    @IBInspectable let startBlue = UIColor(hex: "#4a4dd8ff")
    @IBInspectable let endBlue = UIColor(hex: "#2cd4d8ff")
    
    override func layoutSubviews() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [startBlue!.cgColor, endBlue!.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.frame = self.bounds
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
}

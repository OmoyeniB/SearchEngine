import UIKit

extension UIView {
    
    func animateView() {
        UIView.animate(withDuration: 1.0, delay: 0.1, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.0, options: [], animations: {
            self.center = CGPoint(x: -100, y: 40 + 200)
        }, completion: nil)
    }
    
    func animateFromTop() {
        UIView.animate(withDuration: 1.0, delay: 0.1, usingSpringWithDamping: 10, initialSpringVelocity: 0.0, options: [], animations: {
            self.center = CGPoint(x: 50, y: 40 + 200)
        }, completion: nil)
    }
}

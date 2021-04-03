//
//  Extensions.swift
//  Cobera
//
//  Created by Emilio Del Castillo on 03/04/2021.
//

import UIKit

extension UIView {
    
    /**
     Gets all the text fields in the view.
     - Parameter view: The view in wich the text fields are. If none is provided, the caller will be used instead
     - Returns : An array of all the text fields.
     */
    func getTextfields(view: UIView! = nil) -> [UITextField] {
    
        var results = [UITextField]()
        for subview in (view ?? self).subviews as [UIView] {
            if let textField = subview as? UITextField {
                results += [textField]
            } else {
                results += getTextfields(view: subview)
            }
        }
        return results
    }
}

extension UITextField {
    
    /**
     Animates the text field.
     */
    func shake() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.05
        animation.repeatCount = 5
        animation.autoreverses = true
        animation.fromValue = CGPoint(x: self.center.x - 4.0, y: self.center.y)
        animation.toValue = CGPoint(x: self.center.x + 4.0, y: self.center.y)
        layer.add(animation, forKey: "position")
    }
}

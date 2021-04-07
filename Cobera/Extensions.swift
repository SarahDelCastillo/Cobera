//
//  Extensions.swift
//  Cobera
//
//  Created by Emilio Del Castillo on 03/04/2021.
//

import Firebase

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

extension UIViewController{
    /**
     Displays an alert to the user with the appropriate message for the error
     - Parameter error: The error that happened
     */
    func handleError(_ error: Error) {
        if let errorCode = AuthErrorCode(rawValue: error._code) {
            print(errorCode.errorMessage)
            displaySimpleAlert(title: "Error", message: errorCode.errorMessage)
            
        }
    }
    
    func displaySimpleAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        present(alert, animated: true)
    }
    
    /**
     Creates and displays an activity indicator.
     - Parameter animating: Determines if the activity indicator starts animating.
     */
    func createActivityIndicator(animating: Bool = true) -> UIActivityIndicatorView {
        
        let spinner = UIActivityIndicatorView(frame: view.frame)
        spinner.style = .large
        spinner.hidesWhenStopped = true
        view.addSubview(spinner)
        
        if animating {
            spinner.startAnimating()
        }
        
        return spinner
    }
}

extension AuthErrorCode {
    var errorMessage: String {
        switch self {
        case .emailAlreadyInUse:
            return "The email is already in use with another account."
        case .userNotFound:
            return "Account not found for the specified user. Please check and try again."
        case .userDisabled:
            return "Your account has been disabled. Please contact support."
        case .invalidEmail, .invalidSender, .invalidRecipientEmail:
            return "Please enter a valid email."
        case .networkError:
            return "Network error. Please try again."
        case .weakPassword:
            return "Your password is too weak. The password must be 6 characters long or more."
        case .wrongPassword:
            return "Your password is incorrect. Please try again." // or use 'Forgot password' to reset your password.
        default:
            return "Unknown error occurred."
        }
    }
}

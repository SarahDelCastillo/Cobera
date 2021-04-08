//
//  AuthenticationViewController+SignInAction.swift
//  Cobera
//
//  Created by Emilio Del Castillo on 06/04/2021.
//

import UIKit

extension AuthenticationViewController {
    
    @IBAction func signInAction(_ sender: UIButton) {
        if isInLoginMode {
            let email = emailTextField.text!
            let password = passwordTextField.text!
            
            let spinner = createActivityIndicator()
            AppData.shared.login(email: email, password: password) { result in
                switch result {
                case .success(_):
                    self.dismiss(animated: true){
                        self.delegate.didLogin()
                    }
                
                case .failure(let error):
                    self.handleError(error)
                }
                spinner.stopAnimating()
            }
            
        } else { // Register
            let email = emailTextField.text!
            let confirmEmail = confirmEmailTextField.text
            let password = passwordTextField.text!
            
            if email != confirmEmail {
                emailTextField.shake()
                confirmEmailTextField.shake()
                
            } else {
                
                let spinner = createActivityIndicator()
                AppData.shared.register(email: email, password: password) { result in
                    switch result {
                    case .success(_):
                        self.dismiss(animated: true)

                    case .failure(let error):
                        self.handleError(error)
                    }
                    spinner.stopAnimating()
                }
            }
        }
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
}

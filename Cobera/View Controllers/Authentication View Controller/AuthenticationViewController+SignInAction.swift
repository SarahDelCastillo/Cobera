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
            
            AppData.shared.login(email: email, password: password) { result in
                switch result {
                case .success(_):
                    self.dismiss(animated: true)
                    // TODO: Load the data from the database
                
                case .failure(let error):
                    self.handleError(error)
                }
            }
            
        } else { // Register
            let email = emailTextField.text!
            let confirmEmail = confirmEmailTextField.text
            let password = passwordTextField.text!
            
            if email != confirmEmail {
                emailTextField.shake()
                confirmEmailTextField.shake()
                
            } else {
                AppData.shared.register(email: email, password: password) { result in
                    switch result {
                    case .success(_):
                        self.dismiss(animated: true)
                        // TODO: Load the data from the database
                    case .failure(let error):
                        self.handleError(error)
                    }
                }
            }
            
        }
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
}

//
//  AuthenticationViewController.swift
//  Cobera
//
//  Created by Emilio Del Castillo on 06/04/2021.
//

import UIKit

class AuthenticationViewController: UIViewController {

    @IBOutlet weak var loginOrRegister: UISegmentedControl!
    
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var mainButton: UIButton!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var confirmEmailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var confirmEmailLabel: UILabel!
    
    
    var isInLoginMode = true
    private var passwordIsHidden = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure the text fields
        emailTextField.delegate = self
        confirmEmailTextField.delegate = self
        passwordTextField.delegate = self
        
        logoutButton.isHidden = !AppData.shared.isLoggedIn
        confirmEmailTextField.isHidden = true
        confirmEmailLabel.isHidden = true
        
        // Don't want to show the password as we type
        passwordTextField.isSecureTextEntry = true
    }
    
    @IBAction func revealPassword(_ sender: UIButton) {
        if passwordIsHidden {
            // Reveal the password
            passwordIsHidden = false
            sender.setImage(UIImage(systemName: "eye.fill"), for: .normal)
            passwordTextField.isSecureTextEntry = false
        } else {
            // Hide the password
            passwordIsHidden = true
            sender.setImage(UIImage(systemName: "eye.slash.fill"), for: .normal)
            passwordTextField.isSecureTextEntry = true
        }
    }
    
    @IBAction func loginRegisterSelector(_ sender: UISegmentedControl) {
        let currentTitle = sender.titleForSegment(at: sender.selectedSegmentIndex)
        mainButton.setTitle(currentTitle, for: .normal)
        
        if sender.selectedSegmentIndex == 0 {
            isInLoginMode = true
            UIView.animate(withDuration: 0.5 ) {
                self.confirmEmailTextField.isHidden = true
                self.confirmEmailLabel.isHidden = true
            }
            
        } else {
            isInLoginMode = false // Register mode
            UIView.animate(withDuration: 0.5 ) {
                self.confirmEmailTextField.isHidden = false
                self.confirmEmailLabel.isHidden = false
            }
        }
    }
    
    @IBAction func forgotPassword(_ sender: UIButton) {
    }
    
    @IBAction func logOut(_ sender: UIButton) {
        // TODO: Notify the user if an error happens
        
        AppData.shared.logout()
        logoutButton.isHidden = true
    }
}

extension AuthenticationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

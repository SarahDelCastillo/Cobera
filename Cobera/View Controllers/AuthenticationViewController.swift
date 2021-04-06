//
//  AuthenticationViewController.swift
//  Cobera
//
//  Created by Emilio Del Castillo on 06/04/2021.
//

import UIKit

class AuthenticationViewController: UIViewController {

    @IBOutlet weak var loginOrRegister: UISegmentedControl!
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var confirmEmailLabel: UILabel!
    @IBOutlet weak var confirmEmailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var mainButton: UIButton!
    
    private var loginMode = true
    private var passwordHidden = true
    
    override func viewDidLoad() {
        view.backgroundColor = .myColor
        super.viewDidLoad()
        confirmEmailTextField.isHidden = true
        confirmEmailLabel.isHidden = true
        
        // Don't want to show the password as we type
        passwordTextField.isSecureTextEntry = true
    }
    
    @IBAction func revealPassword(_ sender: UIButton) {
        if passwordHidden {
            // Reveal the password
            passwordHidden = false
            sender.setImage(UIImage(systemName: "eye.fill"), for: .normal)
            passwordTextField.isSecureTextEntry = false
        } else {
            // Hide the password
            passwordHidden = true
            sender.setImage(UIImage(systemName: "eye.slash.fill"), for: .normal)
            passwordTextField.isSecureTextEntry = true
        }
    }
    
    @IBAction func loginRegisterSelector(_ sender: UISegmentedControl) {
        let currentTitle = sender.titleForSegment(at: sender.selectedSegmentIndex)
        
        if sender.selectedSegmentIndex == 0 {
            loginMode = true
            confirmEmailTextField.isHidden = true
            confirmEmailLabel.isHidden = true
        } else {
            loginMode = false // Register mode
            confirmEmailTextField.isHidden = false
            confirmEmailLabel.isHidden = false
        }
        mainButton.setTitle(currentTitle, for: .normal)
    }
    
    
    @IBAction func forgotPassword(_ sender: UIButton) {
    }
    @IBAction func logOut(_ sender: UIButton) {
    }
    @IBAction func signInAction(_ sender: UIButton) {
        if loginMode {
            let email = emailTextField.text
            let password = passwordTextField.text
            // Back-end stuff here
            if email == "test" && password == "test" {
                print ("Success.")
            }
        } else { // Register
            let email = emailTextField.text
            let confirmEmail = confirmEmailTextField.text
            let password = passwordTextField.text
            
            if email != confirmEmail {
                print ("The emails don't match.")
            } else {
                print ("Registered successfully.")
            }
            
        }
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
}

extension UIColor {
    public static var myColor: UIColor {
        return UIColor(named: "myColor")!
    }
}

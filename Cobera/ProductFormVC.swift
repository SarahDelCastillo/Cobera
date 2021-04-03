//
//  ProductFormVC.swift
//  Cobera
//
//  Created by Emilio Del Castillo on 02/04/2021.
//

import UIKit

class ProductFormVC: UIViewController, QuantityStepperViewControllerDelegate {

    @IBOutlet weak var barcodeLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var brandTextField: UITextField!
    @IBOutlet weak var capacityTextField: UITextField!
    @IBOutlet weak var unitTextField: UITextField!
    
    var manuallyAdded = false
    
    var barcode: String!
    var product: Product?
    var quantity: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isModalInPresentation = true
        barcodeLabel.text = barcode
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Dismiss the keyboard
        view.endEditing(true)
    }
    
    @IBAction func addProduct(_ sender: UIButton) {
        
        if !checkForEmptyTextFields() {
            
            // There aren't any empty text fields
            let brand = brandTextField.text!
            let name = nameTextField.text!
            let capacity = Int(capacityTextField.text!)!
            guard let unit = CapacityUnit(rawValue: unitTextField.text!) else {
                unitTextField.shake()
                return
            }
            
            if manuallyAdded {
                barcode = Product.getUniqueIdentifier(brand: brand, name: name, capacity: capacity, capacityUnit: unit)
            }
            
            // TODO: Notify the user when a wrong unit is input
            let newProduct = Product(barcode: barcode,
                                     brand: brand,
                                     name: name,
                                     capacity: capacity,
                                     capacityUnit: unit)
            
            if !manuallyAdded {
                AppData.shared.writeNewProductToDatabase(newProduct)
            }

            AppData.shared.addProduct(newProduct, quantity)
            performSegue(withIdentifier: Segues.addNewProduct, sender: nil)
                
        }
    }
    
    /**
     Checks for any empty text field in the view, and shakes the empty ones.
     - Returns : true if there are empty text fields.
     */
    func checkForEmptyTextFields() -> Bool {
        var emptyTextField = false
        let textFields = getTextfields(view: view)
        for textField in textFields {
            if textField.text == "" {
                textField.shake()
                emptyTextField = true
            }
        }
        return emptyTextField
    }
    
    /**
     Gets all the text fields in the view.
     - Parameter view: The view in wich the text fields are.
     - Returns : An array of all the text fields.
     */
    func getTextfields(view: UIView) -> [UITextField] {
        var results = [UITextField]()
        for subview in view.subviews as [UIView] {
            if let textField = subview as? UITextField {
                results += [textField]
            } else {
                results += getTextfields(view: subview)
            }
        }
        return results
    }
    
    func updateQuantity(_ quantity: Int) {
        self.quantity = quantity
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.embedQuantity {
            if let destinationVC = segue.destination as? QuantityStepperViewController {
                destinationVC.delegate = self
            }
            return
        }
    }
}

extension UITextField {
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

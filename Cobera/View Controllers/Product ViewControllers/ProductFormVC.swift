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
            guard let unit = Product.CapacityUnit(rawValue: unitTextField.text!) else {
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

            let type: UserItem.TypeOfAddition = manuallyAdded ? .manual : .scanned
            AppData.shared.addProduct(newProduct, quantity, type: type)
            performSegue(withIdentifier: Segues.addNewProduct, sender: nil)
                
        }
    }
    
    /**
     Checks for any empty text field in the view, and shakes the empty ones.
     - Returns : true if there are empty text fields.
     */
    func checkForEmptyTextFields() -> Bool {
        var emptyTextField = false
        let textFields = view.getTextfields()
        for textField in textFields {
            if textField.text == "" {
                textField.shake()
                emptyTextField = true
            }
        }
        return emptyTextField
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

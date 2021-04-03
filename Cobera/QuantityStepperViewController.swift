//
//  QuantityStepperView.swift
//  Cobera
//
//  Created by Emilio Del Castillo on 02/04/2021.
//

import UIKit

protocol QuantityStepperViewControllerDelegate {
    func updateQuantity(_ quantity: Int)
}

class QuantityStepperViewController: UIViewController {
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var quantityStepper: UIStepper!
    
    var quantity: Int!
    
    var delegate: QuantityStepperViewControllerDelegate!
    
    override func viewDidLoad() {
        quantity = Int(quantityStepper.value)
        delegate.updateQuantity(quantity)
    }
    
    @IBAction func updateValue(_ sender: UIStepper) {
        quantity = Int(sender.value)
        quantityLabel.text = quantity.description
        delegate.updateQuantity(quantity)
    }
}

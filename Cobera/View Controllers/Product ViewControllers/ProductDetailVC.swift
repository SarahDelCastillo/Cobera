//
//  ProductDetailVC.swift
//  Cobera
//
//  Created by Emilio Del Castillo on 02/04/2021.
//

import UIKit

class ProductDetailVC: UIViewController, QuantityStepperViewControllerDelegate {

    
    @IBOutlet weak var barcodeLabel: UILabel!
    @IBOutlet weak var brandLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var capacityLabel: UILabel!
    @IBOutlet weak var unitLabel: UILabel!
    
    var quantity: Int!
    
    var product: Product!
    override func viewDidLoad() {
        super.viewDidLoad()
        isModalInPresentation = true
        updateOutlets()
    }
    
    func updateOutlets() {
        barcodeLabel.text   = product.barcode
        brandLabel.text     = product.brand
        nameLabel.text      = product.name
        capacityLabel.text  = product.capacity.description
        unitLabel.text      = product.capacityUnit.rawValue
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
        
        if segue.identifier == Segues.addExistingProduct {
            let destinationVC = segue.destination
            print(destinationVC)
            return
        }
    }
    
    @IBAction func addProduct() {
        print("adding", quantity!, "of", product.debugDescription)
        AppData.shared.addProduct(product, quantity, type: .scanned)
        performSegue(withIdentifier: Segues.addExistingProduct, sender: nil)
    }
}

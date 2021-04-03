//
//  AddProductVC.swift
//  Cobera
//
//  Created by Emilio Del Castillo on 01/04/2021.
//

import UIKit

class AddProductVC: UIViewController, ScannerViewControllerDelegate {

    var barcode: String!
    
    func found(code: String) {
        barcode = code
        self.performSegue(withIdentifier: "show product form", sender: self)
        
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "show scanner":
            if let destinationVC = segue.destination as? ScannerViewController {
                destinationVC.delegate = self
            }
            
        case "show product form":
            if let destinationVC = segue.destination as? ProductFormVC {
                destinationVC.barcode = barcode
            }
            
        case "manually show product form":
            if let destinationVC = segue.destination as? ProductFormVC {
                destinationVC.manuallyAdded = true
                destinationVC.barcode = barcode
            }
            
            
        default:
            print("DEBUG: Unknown segue!")
        }
        
    }
    
    @IBAction func showScanner(_ sender: UIButton) {
        performSegue(withIdentifier: "show scanner", sender: self)
    }
    
    @IBAction func addProductManually(_ sender: UIButton) {
        performSegue(withIdentifier: "manually show product form", sender: nil)
    }
    
    @IBAction func cancel(_ unwindSegue: UIStoryboardSegue) {
        let sourceViewController = unwindSegue.source
        print ("Unwind cancel, from", sourceViewController)
    }
    
    @IBAction func addTest(_ unwindSegue: UIStoryboardSegue) {
        let sourceViewController = unwindSegue.source
        print("Unwind addTest, from", sourceViewController)
    }
}

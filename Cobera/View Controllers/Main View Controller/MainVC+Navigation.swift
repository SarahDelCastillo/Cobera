//
//  MainVC+Navigation.swift
//  Cobera
//
//  Created by Emilio Del Castillo on 08/04/2021.
//

import UIKit

extension MainVC {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.showAuth {
            let destinationVC = segue.destination as! AuthenticationViewController
            destinationVC.delegate = self
        }
    }
}

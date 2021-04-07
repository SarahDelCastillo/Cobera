//
//  AppData+WriteToDatabase.swift
//  Cobera
//
//  Created by Emilio Del Castillo on 03/04/2021.
//

import Foundation

extension AppData {
    func writeNewProductToDatabase(_ product: Product) {
        let update = ["Products/\(product.barcode)": product.dictionary]
        rootNode.updateChildValues(update)
    }
    
    func writeItemToDatabase(item: UserItem){
        guard isLoggedIn else { return }
        
        let itemType = item.type.rawValue
        let itemId = item.product.barcode
        
        let path = "Users/\(userId!)/items/\(itemType)/\(itemId)"
        
        var update = [String: Any]()
        if item.type == .manual {
            update = [path: ["quantity": "\(item.quantity)",
                             "product": item.product.dictionary]]
            
        } else {
            update = [path: ["quantity": "\(item.quantity)"]]
        }
        
        rootNode.updateChildValues(update)
    }
}

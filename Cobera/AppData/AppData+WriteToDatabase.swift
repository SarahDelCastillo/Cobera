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
    
    func writeItemsToDatabase(items: [UserItem]){
        guard isLoggedIn else { return }
        
        var update = [String: Any]()
        var path = "Users/\(userId!)/items/"
        
        for item in items {
            let itemType = item.type.rawValue
            let itemId = item.product.barcode
            path += "\(itemType)/\(itemId)"
            if item.type == .manual {
                update[path] = ["quantity": "\(item.quantity)",
                                "dateAdded": "\(item.dateString)",
                                "product": item.product.dictionary]
                
            } else {
                update[path] = ["quantity": "\(item.quantity)",
                                "dateAdded": "\(item.dateString)"]
            }
        }
        
        rootNode.updateChildValues(update)
    }
}

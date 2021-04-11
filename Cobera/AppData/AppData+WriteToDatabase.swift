//
//  AppData+WriteToDatabase.swift
//  Cobera
//
//  Created by Emilio Del Castillo on 03/04/2021.
//

import Foundation

extension AppData {
    func writeNewProductToDatabase(_ product: Product) {
        let update = ["Products/\(product.identifier)": product.dictionary]
        rootNode.updateChildValues(update)
    }
    
    func writeItemsToDatabase(items: [UserItem]){
        guard isLoggedIn else { return }
        
        var update = [String: Any]()
        var path: String
        
        for item in items {
            path = "Users/\(userId!)/items/"
            let itemType = item.type.rawValue
            let itemId = item.product.identifier
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
    
    func deleteItemFromDatabase(item: UserItem){
        guard isLoggedIn else { return }
        
        let itemType = item.type.rawValue
        let itemId = item.product.identifier
        let path = "Users/\(userId!)/items/\(itemType)/\(itemId)"
        
        rootNode.child(path).removeValue()
    }
    
    func deleteEverythingFromDatabase() {
        guard isLoggedIn else { return }
        
        rootNode.child("Users/\(userId!)").removeValue()
        writeItemsToDatabase(items: userItems)
    }
}

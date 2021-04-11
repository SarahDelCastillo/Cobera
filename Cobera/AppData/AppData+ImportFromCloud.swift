//
//  AppData+ImportFromCloud.swift
//  Cobera
//
//  Created by Emilio Del Castillo on 08/04/2021.
//

import Foundation

extension AppData {
    
    /**
     Merges the given array of `UserItem` into the local one.
     - Parameter items: The array of items to merge.
     */
    func merge(items: [UserItem]) {
        for item in items {
            // Prevent duplicates
            if let duplicate = userItems.firstIndex(where: { product in
                product.product.identifier == item.product.identifier
            }) {
                userItems[duplicate].quantity += item.quantity
                
            } else {
                // No similar item has been found locally
                userItems.append(item)
            }
        }
        updateStoredProducts()
        writeItemsToDatabase(items: userItems)
    }
}

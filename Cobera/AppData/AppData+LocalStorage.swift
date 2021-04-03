//
//  AppData+LocalStorage.swift
//  Cobera
//
//  Created by Emilio Del Castillo on 03/04/2021.
//

import Foundation

extension AppData {
    
    func addProduct(_ newProduct: Product, _ quantity: Int) {
        guard userItems != nil else { return }
        print("Adding product...")
        
        // Prevent duplicates:
        if let duplicate = userItems.firstIndex(where: { product in
            product.product.barcode == newProduct.barcode
        }) {
            userItems[duplicate].quantity += quantity
        } else {
            userItems.append(UserProduct(product: newProduct, quantity: quantity))
        }
        
        updateStoredProducts()
    }
    
    func updateStoredProducts() {
        guard userItems != nil else { return }
        let dataPath = docsURL.appendingPathComponent(documentName)
        
        do {
            let archiver = try NSKeyedArchiver.archivedData(withRootObject: userItems!, requiringSecureCoding: false)
            try archiver.write(to: dataPath)
            print("Successfully stored products")
        } catch {
            print(error)
        }
    }
    
    /**
     Updates the quantity of the item at the given row
     - Parameter newQuantity: The updated quantity
     - Parameter row: The index of the item to update
     */
    func updateQuantity(_ newQuantity: Int, forRow row: Int){
        assert(userItems != nil, "userItems has not been initialized.")
        userItems[row].quantity = newQuantity
        updateStoredProducts()
    }
    
    func getStoredProducts() {
        let dataPath = docsURL.appendingPathComponent(documentName)
        if let data = try? Data(contentsOf: dataPath) {
            do {
                let foundProducts = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [UserProduct]
                userItems = foundProducts
                
            } catch {
                print(error)
                userItems = []
            }
        } else {
            userItems = []
        }
    }
}

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
}

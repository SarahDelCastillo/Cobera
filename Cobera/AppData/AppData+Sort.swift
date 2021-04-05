//
//  AppData+Sort.swift
//  Cobera
//
//  Created by Emilio Del Castillo on 04/04/2021.
//

import Foundation

extension AppData {
    
    func sort(by: SortingParameter, order: SortingOrder) {
        guard userItems != nil else { return }
        userItems.sort { first, second in
            
            switch (by, order) {
            case (.quantity, .desc):
                return first.quantity > second.quantity
                
            case (.quantity, .asc):
                return first.quantity < second.quantity
                
            case (.name, .desc):
                return first.product.name > second.product.name
                
            case (.name, .asc):
                return first.product.name < second.product.name
            }
        }
        updateStoredProducts()
    }
}

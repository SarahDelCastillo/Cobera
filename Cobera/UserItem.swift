//
//  UserItem.swift
//  Cobera
//
//  Created by Emilio Del Castillo on 07/04/2021.
//

import Foundation

class UserItem: NSObject, NSCoding {
    enum TypeOfAddition: String {
        case scanned, manual
    }
    
    var product: Product
    var quantity: Int
    var type: TypeOfAddition
    
    func encode(with coder: NSCoder) {
        coder.encode(product, forKey: "product")
        coder.encode(quantity, forKey: "quantity")
        coder.encode(type.rawValue, forKey: "type")
    }
    
    required convenience init?(coder: NSCoder) {
        let prod = coder.decodeObject(forKey: "product") as! Product
        let quant = coder.decodeInteger(forKey: "quantity")
        let type = TypeOfAddition(rawValue: (coder.decodeObject(forKey: "type")) as! String)!
        
        self.init(product: prod, quantity: quant, type)
    }
    
    init(product: Product, quantity: Int, _ typeOfAddition: TypeOfAddition) {
        self.product = product
        self.quantity = quantity
        self.type = typeOfAddition
    }
    
}

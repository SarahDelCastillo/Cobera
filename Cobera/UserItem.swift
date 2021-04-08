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
    private var dateOfCreation: Date!
    
    /**
     A time interval used to create a Date object.
     
     Usage:
     ```
     let date = Date(timeIntervalSinceReferenceDate: dateString)
     ```
     */
    var dateString: String {
        dateOfCreation.timeIntervalSinceReferenceDate.description
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(product, forKey: "product")
        coder.encode(quantity, forKey: "quantity")
        coder.encode(type.rawValue, forKey: "type")
        coder.encode(dateString, forKey: "dateOfCreation")
    }
    
    required convenience init?(coder: NSCoder) {
        let prod        = coder.decodeObject(forKey: "product") as! Product
        let quant       = coder.decodeInteger(forKey: "quantity")
        let type        = TypeOfAddition(rawValue: (coder.decodeObject(forKey: "type")) as! String)!
        let dateString  = coder.decodeObject(forKey: "dateOfCreation") as! String
        let date        = Date(timeIntervalSinceReferenceDate: TimeInterval(dateString)!)
        self.init(product: prod, quantity: quant, type, date: date)
    }
    
    init(product: Product, quantity: Int, _ typeOfAddition: TypeOfAddition, date: Date? = nil) {
        self.product  = product
        self.quantity = quantity
        self.type     = typeOfAddition
        self.dateOfCreation = date ?? Date()
    }
    
}

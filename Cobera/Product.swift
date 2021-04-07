//
//  Product.swift
//  Cobera
//
//  Created by Emilio Del Castillo on 01/04/2021.
//

import Foundation

class Product: NSObject, NSCoding {
    enum CapacityUnit: String, CaseIterable {
        case mililitre = "ml"
        case centilitre = "cl"
        case litre = "l"
        case gram = "g"
        case kilo = "kg"
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(barcode, forKey: "barcode")
        coder.encode(brand, forKey: "brand")
        coder.encode(name, forKey: "name")
        coder.encode(capacity, forKey: "capacity")
        coder.encode(capacityUnit.rawValue, forKey: "capacityUnit")
    }
    
    required convenience init?(coder: NSCoder) {
        let barcode = coder.decodeObject(forKey: "barcode") as! String
        let brand = coder.decodeObject(forKey: "brand") as! String
        let name = coder.decodeObject(forKey: "name") as! String
        let capacity = coder.decodeInteger(forKey: "capacity")
        let capacityUnit = CapacityUnit(rawValue: coder.decodeObject(forKey: "capacityUnit") as! String)!
        
        self.init(barcode: barcode, brand: brand, name: name, capacity: capacity, capacityUnit: capacityUnit)
    }
    
    
    var barcode: String
    
    var brand: String
    var name: String
    
    var capacity: Int
    var capacityUnit: CapacityUnit
    
    var dictionary: [String: Any] {
        return ["name": name,
                "brand": brand,
                "capacity": capacity,
                "capacityUnit": capacityUnit.rawValue]
    }
    
    init(barcode: String, brand: String, name: String, capacity: Int, capacityUnit: CapacityUnit) {
        self.barcode = barcode
        self.brand = brand
        self.name = name
        self.capacity = capacity
        self.capacityUnit = capacityUnit
    }
    
    /**
     Returns a hopefully unique identifier for a product without barcode.
     - Parameters:
        - brand: The product brand
        - name: The product name
        - capacity: The product capacity
        - capacityUnit: The unit (e.g., ml)
     
    When a product is added manually, no barcode is provided. This function should help to identify it.
     */
    class func getUniqueIdentifier(brand: String, name: String, capacity: Int, capacityUnit: CapacityUnit) -> String {
        return brand + name + capacity.description + capacityUnit.rawValue
    }
}

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

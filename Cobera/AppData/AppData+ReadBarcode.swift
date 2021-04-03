//
//  AppData+ReadBarcode.swift
//  Cobera
//
//  Created by Emilio Del Castillo on 03/04/2021.
//

import Foundation

extension AppData {
    func readBarcode(_ barcode: String, completion: @escaping (Product?) -> Void) {
        rootNode.child("Products").child(barcode).observeSingleEvent(of: .value) { (snapshot) in
            if snapshot.value is NSNull {
                print("Barcode didn't match any existing product.")
                completion(nil)
                
            } else {
                guard let data = snapshot.value as? NSDictionary,
                      let name = data["name"] as? String,
                      let brand = data["brand"] as? String,
                      let capacity = data["capacity"] as? Int,
                      let capacityUnit = data["capacityUnit"] as? String
                
                else {
                    // FIXME: Make a list of possible errors
                    print("Incorrect data:", snapshot.value!)
                    completion(nil)
                    return
                }
                
                print("readBarCode: found", brand, name)
                
                let foundProduct = Product(barcode: barcode,
                                           brand: brand,
                                           name: name,
                                           capacity: capacity,
                                           capacityUnit: CapacityUnit(rawValue: capacityUnit)!)
                completion(foundProduct)
            }
        }
    }
}

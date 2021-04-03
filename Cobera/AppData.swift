//
//  AppData.swift
//  Cobera
//
//  Created by Emilio Del Castillo on 02/04/2021.
//

import Firebase

class AppData {
    static let shared = AppData()
    
    // Firebase access
    var auth: Auth!
    var rootNode: DatabaseReference!
    
    // Local access
    let docsURL: URL!
    let documentName = "user_products.plist"
    var userItems: [UserProduct]!
    
    
    init(){
        auth = Auth.auth()
        rootNode = Database.database().reference()
        
        do {
            docsURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            getStoredProducts()
        } catch {
            docsURL = nil
            print(error)
        }
    }
}

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

extension AppData {
    func writeNewProductToDatabase(_ product: Product) {
        let update = ["Products/\(product.barcode)": product.dictionary]
        rootNode.updateChildValues(update)
    }
    
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
    
    private func getStoredProducts() {
        let dataPath = docsURL.appendingPathComponent(documentName)
        if let data = try? Data(contentsOf: dataPath) {
            do {
                let foundProducts = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [UserProduct]
                userItems = foundProducts
                for product in foundProducts! {
                    print(product.product.name)
                }
                
            } catch {
                print(error)
                userItems = []
            }
        } else {
            userItems = []
        }
    }
}

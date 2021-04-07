//
//  AppData+ReadFromDatabase.swift
//  Cobera
//
//  Created by Emilio Del Castillo on 07/04/2021.
//

import Foundation

extension AppData {
    
    /**
     Reads all the manually added items from the database.
     
     - Parameter completion: The closure to be executed after the network call returns.
     - Parameter result: The result of the network call. It may contain an array of UserItem.
     */
    func readManualItems(completion: @escaping (_ result: Result<[UserItem], DatabaseError>) -> Void) {
        guard isLoggedIn else { return }
        
        let path = "Users/\(userId!)/items/manual"
        
        rootNode.child(path).observeSingleEvent(of: .value) { snapshot in
            
            guard let data = snapshot.value as? NSDictionary else {
                // Usually this means that data is NSNull
                completion(.failure(.wrongData))
                return
            }
            
            if let productIds = data.allKeys as? [String] {
                var items = [UserItem]()
                for id in productIds {
                    guard let item         = data[id] as? [String: Any],
                          let quantityStr  = item["quantity"] as? String,
                          let quantity     = Int(quantityStr),
                          let prod         = item["product"] as? [String: Any],
                          let brand        = prod["brand"] as? String,
                          let name         = prod["name"] as? String,
                          let capacity     = prod["capacity"] as? Int,
                          let unit         = prod["capacityUnit"] as? String,
                          let capacityUnit = Product.CapacityUnit(rawValue: unit)
                    
                    else {
                        completion(.failure(.wrongData))
                        return
                    }
                    
                    let product = Product(barcode: id, brand: brand, name: name, capacity: capacity, capacityUnit: capacityUnit)
                    items.append(UserItem(product: product, quantity: quantity, .manual))
                }
                completion(.success(items))
                return
                
            } else {
                // Failure to get the ids
                completion(.failure(.wrongData))
            }
        }
    }
    
    func readScannedItems(completion: @escaping (_ result: Result<[UserItem], DatabaseError>) -> Void ){
        guard isLoggedIn else { return }
        
        let path = "Users/\(userId!)/items/scanned"
        
        rootNode.child(path).observeSingleEvent(of: .value) { snapshot in
            guard let data = snapshot.value as? NSDictionary else {
                // Usually this means that data is NSNull
                completion(.failure(.wrongData))
                return
            }
            
            if let productIds = data.allKeys as? [String] {
                var items = [UserItem]()
                
                // This code calls another asynchronous function.
                // This dispatchGroup allows it to return only when all tasks have been completed.
                let dispatchGroup = DispatchGroup()
                
                for id in productIds {
                    dispatchGroup.enter()
                    guard let item        = data[id] as? [String: Any],
                          let quantityStr = item["quantity"] as? String,
                          let quantity    = Int(quantityStr)
                    else {
                        dispatchGroup.leave()
                        completion(.failure(.wrongData))
                        return
                    }
                    
                    self.readBarcode(id) { result in
                        
                        switch result {
                        case .success(let product):
                            items.append(UserItem(product: product, quantity: quantity, .scanned))
                            dispatchGroup.leave()
                            
                        case .failure(let error):
                            dispatchGroup.leave()
                            completion(.failure(error))
                            return
                        }
                    }
                }
                dispatchGroup.notify(queue: DispatchQueue.main) {
                    print("Dispatch done!")
                    // All the tasks are successfully complete
                    completion(.success(items))
                    return
                }
                
            } else {
                // Failure to get the ids
                completion(.failure(.wrongData))
            }
        }
    }
}

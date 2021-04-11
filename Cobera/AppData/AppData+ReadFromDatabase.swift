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
        // FIXME: Add something in order to retrieve a maximum of items even if some have errors
        guard isLoggedIn else { return }
        
        let path = "Users/\(userId!)/items/manual"
        
        rootNode.child(path).observeSingleEvent(of: .value) { snapshot in
            
            guard let data = snapshot.value as? NSDictionary else {
                // Usually this means that data is NSNull
                // It means that the user hasn't uploaded any items yet.
                completion(.success([]))
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
                          let capacityUnit = Product.CapacityUnit(rawValue: unit),
                          let dateString   = item["dateAdded"] as? String,
                          let dateSource   = TimeInterval(dateString)
                    
                    else {
                        completion(.failure(.wrongData))
                        return
                    }
                    
                    let product = Product(identifier: id, brand: brand, name: name, capacity: capacity, capacityUnit: capacityUnit)
                    
                    let date = Date(timeIntervalSinceReferenceDate: dateSource)
                    items.append(UserItem(product: product, quantity: quantity, .manual, date: date))
                }
                completion(.success(items))
                return
                
            } else {
                // Failure to get the ids
                completion(.failure(.wrongData))
            }
        }
    }
    
    /**
     Reads all the scanned items from the database.
     - Parameter completion: The closure to be executed after the network call returns.
     - Parameter result: The result of the network call. It may contain an array of UserItem.
     */
    func readScannedItems(completion: @escaping (_ result: Result<[UserItem], DatabaseError>) -> Void ){
        // FIXME: Add something in order to retrieve a maximum of items even if some have errors
        guard isLoggedIn else { return }
        
        let path = "Users/\(userId!)/items/scanned"
        
        rootNode.child(path).observeSingleEvent(of: .value) { snapshot in
            guard let data = snapshot.value as? NSDictionary else {
                // Usually this means that data is NSNull
                // It means that the user hasn't uploaded any items yet.
                completion(.success([]))
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
                          let quantity    = Int(quantityStr),
                          let dateString   = item["dateAdded"] as? String,
                          let dateSource   = TimeInterval(dateString)
                    
                    else {
                        dispatchGroup.leave()
                        completion(.failure(.wrongData))
                        return
                    }
                    
                    self.readBarcode(id) { result in
                        
                        switch result {
                        case .success(let product):
                            let date = Date(timeIntervalSinceReferenceDate: dateSource)
                            items.append(UserItem(product: product, quantity: quantity, .scanned, date: date))
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
    
    /**
     Reads all the items from the database.
     - Parameter completion: The closure to be executed after the network call returns.
     - Parameter result: The result of the network call.
     
     The completion closure might be called up to three times depending on results from network calls.
     At least one of those calls is guaranteed to have an array of UserItem, though it might be empty.
     */
    func readAllItems(completion: @escaping (_ result: Result<[UserItem], DatabaseError>) -> Void) {
        var items = [UserItem]()
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        readManualItems { result in
            switch result {
            case .success(let manualItems):
                items += manualItems
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
        
        readScannedItems { result in
            switch result {
            case .success(let scannedItems):
                items += scannedItems
                dispatchGroup.leave()
                
            case .failure(let error):
                completion(.failure(error))
                dispatchGroup.leave()
            }
        }
        dispatchGroup.notify(queue: .main) {
            completion(.success(items))
        }
    }
}

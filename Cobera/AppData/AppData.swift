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



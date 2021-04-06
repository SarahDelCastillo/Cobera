//
//  AppData.swift
//  Cobera
//
//  Created by Emilio Del Castillo on 02/04/2021.
//

import Firebase

class AppData {
    static let shared = AppData()
    
    //MARK: - Firebase access
    var auth: Auth!
    var rootNode: DatabaseReference!
    
    //MARK: - Local access
    let docsURL: URL!
    let documentName = "user_products.plist"
    var userItems: [UserProduct]!
    
    //MARK: - User defaults
    let defaults: UserDefaults = {
        UserDefaults.standard
    }()
    
    var currentSortingOrder: SortingOrder! {
        didSet {
            defaults.setValue(currentSortingOrder.rawValue, forKey: "sortingOrder")
            defaults.synchronize()
        }
    }
    var currentSortingParameter: SortingParameter! {
        didSet {
            defaults.setValue(currentSortingParameter.rawValue, forKey: "sortingParameter")
            defaults.synchronize()
        }
    }
    
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
        
        loadUserPreferences()
    }
}

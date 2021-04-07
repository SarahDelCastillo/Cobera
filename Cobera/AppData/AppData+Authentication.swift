//
//  AppData+Authentication.swift
//  Cobera
//
//  Created by Emilio Del Castillo on 06/04/2021.
//

import Firebase

extension AppData {
    var isLoggedIn: Bool {
        get {
            auth.currentUser != nil
        }
    }
    var userId: String? {
        auth.currentUser?.uid
    }
    
    func register(email: String, password: String, completion: @escaping (Result<AuthDataResult?, Error>) -> Void) {
        auth.createUser(withEmail: email, password: password) { (result, error) in
            if error == nil {
                completion(.success(result))
            } else {
                completion(.failure(error!))
            }
        }
    }
    
    func login(email: String, password: String, completion: @escaping (Result<AuthDataResult?, Error>) -> Void) {
        auth.signIn(withEmail: email, password: password) { (result, error) in
            if error == nil {
                completion(.success(result))
            } else {
                completion(.failure(error!))
            }
        }
    }
    
    func logout() {
        do {
            try auth.signOut()
        } catch {
            print(error)
        }
    }
}

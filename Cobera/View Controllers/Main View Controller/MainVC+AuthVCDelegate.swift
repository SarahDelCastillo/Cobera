//
//  MainVC+AuthVCDelegate.swift
//  Cobera
//
//  Created by Emilio Del Castillo on 08/04/2021.
//

import UIKit

extension MainVC: AuthenticationViewControllerDelegate {
    func didLogin() {
        let spinner = createActivityIndicator()
        
        AppData.shared.readAllItems { result in
            switch result {
            case .success(let items):
                self.handleItems(items: items)
                
            case .failure(let error):
                self.handleFailure(error)
            }
            spinner.stopAnimating()
        }
    }
    
    /**
     Handle the possible `[UserItem]` payload that arrives when a user logs in.
     - Parameter items: An array of `UserItem`
     
     It presents an alert with the possible actions.
     */
    private func handleItems(items: [UserItem]) {
        if items.count > 0 && AppData.shared.userItems.count > 0 {
            let message = """
                Your account has items on the cloud.
                What do you want to do?
                """
            let alert = UIAlertController(title: "Items found", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Merge with local items", style: .default, handler: { _ in
                AppData.shared.merge(items: items)
                self.reloadTableViewData()
            }))
            alert.addAction(UIAlertAction(title: "Discard local items", style: .destructive, handler: { _ in
                AppData.shared.userItems = items
                self.reloadTableViewData()
            }))
            alert.addAction(UIAlertAction(title: "Discard cloud items", style: .destructive, handler: { _ in
                // TODO: AppData.destroy cloud
            }))
            
            present(alert, animated: true)
        }
    }
    
    /**
     Handle the possible failures that happen while retrieving the user's items from the cloud.
     - Parameter error: The error given by the network call
     
     It presents an alert informing the user of what happened, and handles the case of multiple calls.
     */
    private func handleFailure(_ error: AppData.DatabaseError) {
        var title: String?
        var message: String?
        switch error {
        case .noData:
            title = "Some data was not found"
            message = nil
        case .wrongData:
            title = "Corrupted data"
            message = "Some data was corrupted."
        }
        
        if let presented = presentedViewController as? UIAlertController {
            // This means an error has already occured.
            presented.title = "Errors occurred."
            presented.message! += "\n\(message!)"
            
        } else {
            displaySimpleAlert(title: title, message: message)
        }
    }
}

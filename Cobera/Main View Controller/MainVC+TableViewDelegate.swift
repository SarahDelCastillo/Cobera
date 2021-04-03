//
//  MainVC+TableViewDelegate.swift
//  Cobera
//
//  Created by Emilio Del Castillo on 03/04/2021.
//

import UIKit

extension MainVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        
        let index = indexPath.row
        AppData.shared.userItems.remove(at: index)
        AppData.shared.updateStoredProducts()
        tableView.deleteRows(at: [indexPath], with: .left)
    }
}

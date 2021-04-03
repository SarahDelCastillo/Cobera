//
//  +TableViewUtilities.swift
//  Cobera
//
//  Created by Emilio Del Castillo on 04/04/2021.
//

import UIKit

extension MenuViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (section == 0) ? SortingOrder.allCases.count : SortingBy.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        if indexPath.section == 0 { // Sorting order
            cell.textLabel?.text = SortingOrder.allCases[indexPath.row].rawValue.localizedCapitalized
            if currentSortingOrder == SortingOrder.allCases[indexPath.row] {
                cell.accessoryType = .checkmark
            }
            
        } else {
            cell.textLabel?.text = SortingBy.allCases[indexPath.row].rawValue.localizedCapitalized
            if currentSortingPreference == SortingBy.allCases[indexPath.row] {
                cell.accessoryType = .checkmark
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 { // Sorting order
            delegate.didSelectSorting(by: currentSortingPreference, order: SortingOrder.allCases[indexPath.row])
        } else {
            delegate.didSelectSorting(by: SortingBy.allCases[indexPath.row], order: currentSortingOrder)
        }
        
        dismiss(animated: true)
    }
}

//
//  MainVC+TableViewDataSource.swift
//  Cobera
//
//  Created by Emilio Del Castillo on 03/04/2021.
//

import UIKit

extension MainVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        AppData.shared.userItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "table Cell", for: indexPath) as! ProductCell
        let currentRow = indexPath.row
        cell.nameLabel.text = AppData.shared.userItems[currentRow].product.name
        cell.brandLabel.text = AppData.shared.userItems[currentRow].product.brand
        cell.currentRow = currentRow
        
        let quantity = AppData.shared.userItems[currentRow].quantity
        cell.quantityLabel.text = "x ".appending(quantity.description)
        cell.quantityStepper.value = Double(quantity)
        
        return cell
    }
}

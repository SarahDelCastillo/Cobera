//
//  ViewController.swift
//  Cobera
//
//  Created by Emilio Del Castillo on 01/04/2021.
//

import UIKit

class MainVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.addProduct {
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
}


extension MainVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        AppData.shared.userItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "table Cell", for: indexPath) as! ProductCell
        cell.nameLabel.text = AppData.shared.userItems[indexPath.row].product.name
        cell.brandLabel.text = AppData.shared.userItems[indexPath.row].product.brand
        cell.quantityLabel.text = "x ".appending( AppData.shared.userItems[indexPath.row].quantity.description)
        
        return cell
    }
}

extension MainVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        
        let index = indexPath.row
        AppData.shared.userItems.remove(at: index)
        AppData.shared.updateStoredProducts()
        tableView.deleteRows(at: [indexPath], with: .left)
    }
}

//
//  ViewController.swift
//  Cobera
//
//  Created by Emilio Del Castillo on 01/04/2021.
//

import UIKit

class MainVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var currentSortingOrder: SortingOrder! {
        get {
            AppData.shared.currentSortingOrder
        }
        set {
            AppData.shared.currentSortingOrder = newValue
        }
    }
    var currentSortingParameter: SortingParameter! {
        get {
            AppData.shared.currentSortingParameter
        }
        set {
            AppData.shared.currentSortingParameter = newValue
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.layer.cornerRadius = 20
        tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    @IBAction func showSortingMenu(_ sender: UIButton) {
        let asc  = SortingOption(text: "Ascending" , isSelected: (currentSortingOrder == .asc) , order: .asc)
        let desc = SortingOption(text: "Descending", isSelected: (currentSortingOrder == .desc), order: .desc)
        
        let sortbyQuantity = SortingOption(text: "Quantity", isSelected: (currentSortingParameter == .quantity) , parameter: .quantity)
        let sortbyName     = SortingOption(text: "Name"    , isSelected: (currentSortingParameter == .name)     , parameter: .name)
        
        presentOptionsPopover(withItems: [[asc, desc], [sortbyQuantity, sortbyName]],
                              fromButton: sender)
    }
    
    @IBAction func showAuthController(_ sender: UIButton) {
        performSegue(withIdentifier: Segues.showAuth, sender: nil)
    }
    
    @IBAction func showSettingsController(_ sender: UIButton) {
        performSegue(withIdentifier: Segues.showSetings, sender: nil)
    }
}

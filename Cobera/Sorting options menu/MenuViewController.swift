//
//  MenuViewController.swift
//  Cobera
//
//  Created by Emilio Del Castillo on 03/04/2021.
//

import UIKit

protocol MenuViewControllerDelegate {
    func didSelectSorting(by: SortingBy, order: SortingOrder)
}

class MenuViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var presentingVC: MainVC!
    var delegate: MenuViewControllerDelegate!
    
    var currentSortingOrder: SortingOrder!
    var currentSortingPreference: SortingBy!

    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self
    }
}

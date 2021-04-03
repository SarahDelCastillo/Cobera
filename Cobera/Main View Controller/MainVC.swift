//
//  ViewController.swift
//  Cobera
//
//  Created by Emilio Del Castillo on 01/04/2021.
//

import UIKit

class MainVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var currentSortingOrder: SortingOrder!
    var currentSortingPreference: SortingBy!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.layer.cornerRadius = 20
        tableView.tableFooterView = UIView()
        
        currentSortingOrder = .asc
        currentSortingPreference = .quantity
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier {
        case Segues.showSortingOptions:
            if let destinationVC = segue.destination as? MenuViewController {
                destinationVC.presentingVC = self
                destinationVC.delegate = self
                destinationVC.currentSortingOrder = currentSortingOrder
                destinationVC.currentSortingPreference = currentSortingPreference
                
                destinationVC.preferredContentSize = CGSize(width: 150, height: 280)
                
                if let ppc = destinationVC.popoverPresentationController {
                    ppc.delegate = self
                    ppc.permittedArrowDirections = .up
                }
            }
            
        default:
            print("Segue: \(segue.identifier ?? "<empty>")")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
}

extension MainVC: UIPopoverPresentationControllerDelegate, MenuViewControllerDelegate {
    func didSelectSorting(by: SortingBy, order: SortingOrder) {
        currentSortingOrder = order
        currentSortingPreference = by
        AppData.shared.sort(by: by, order: order)
        tableView.reloadData()
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        .none
    }
}

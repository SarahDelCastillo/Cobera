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
    var currentSortingParameter: SortingParameter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.layer.cornerRadius = 20
        tableView.tableFooterView = UIView()
        
        currentSortingOrder = .asc
        currentSortingParameter = .quantity
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    @IBAction func showSortingMenu(_ sender: UIButton){
        let asc  = SortingOption(text: "Ascending" , isSelected: (currentSortingOrder == .asc) , order: .asc)
        let desc = SortingOption(text: "Descending", isSelected: (currentSortingOrder == .desc), order: .desc)
        
        let sortbyQuantity = SortingOption(text: "Quantity", isSelected: (currentSortingParameter == .quantity) , parameter: .quantity)
        let sortbyName     = SortingOption(text: "Name"    , isSelected: (currentSortingParameter == .name)     , parameter: .name)
        
        presentOptionsPopover(withItems: [[asc, desc], [sortbyQuantity, sortbyName]],
                              fromButton: sender)
    }
}

extension MainVC: UIPopoverPresentationControllerDelegate, OptionItemListViewControllerDelegate {
    func didSelectOptionItem(from viewController: OptionPopoverViewController, with item: OptionItem) {
        guard let item = item as? SortingOption else {
            fatalError("The given item is not a sorting option")
        }
        
        viewController.dismiss(animated: true) {
            // Update the sorting preferences. An item has not both parameters (order and parameter)
            // so we need to keep our current parameter if the item returns nil
            self.currentSortingOrder     = item.order ?? self.currentSortingOrder
            self.currentSortingParameter = item.parameter ?? self.currentSortingParameter
            
            AppData.shared.sort(by: self.currentSortingParameter,
                                order: self.currentSortingOrder)
            DispatchQueue.main.async {
                let allSections = 0..<self.tableView.numberOfSections
                self.tableView.reloadSections(IndexSet(allSections), with: .automatic)
            }
        }
    }
    
    func presentOptionsPopover(withItems items: [[OptionItem]], fromButton button: UIButton) {
        let popoverMenu = OptionPopoverViewController()
        popoverMenu.items = items
        popoverMenu.delegate = self
        
        let popoverPresentationController = popoverMenu.popoverPresentationController!
        
        popoverPresentationController.sourceView = button
        popoverPresentationController.delegate = self
        
        present(popoverMenu, animated: true)
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        .none
    }
}

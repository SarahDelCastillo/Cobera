//
//  MainVC+Popover.swift
//  Cobera
//
//  Created by Emilio Del Castillo on 06/04/2021.
//

import UIKit

extension MainVC: UIPopoverPresentationControllerDelegate, OptionItemListViewControllerDelegate {
    func didSelectOptionItem(from viewController: OptionPopoverViewController, with item: OptionItem) {
        guard let item = item as? SortingOption else {
            fatalError("The given item is not a sorting option")
        }
        
        viewController.dismiss(animated: true) {
            // Update the sorting preferences. An item has not both parameters (order and parameter)
            // so we need to keep our current parameter if the item returns nil
            self.currentSortingOrder = item.order ?? self.currentSortingOrder
            self.currentSortingParameter = item.parameter ?? self.currentSortingParameter
            
            AppData.shared.sortItems()
            
            self.reloadTableViewData()
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

//
//  OptionItemListViewController+TableView utilities.swift
//  Popover
//
//  Created by Emilio Del Castillo on 04/04/2021.
//

import UIKit

extension OptionPopoverViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        let item = items[indexPath.section][indexPath.row]
        cell.configure(with:item)
        return cell
    }
}

extension OptionPopoverViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items[indexPath.section][indexPath.row]
        delegate?.didSelectOptionItem(from: self, with: item)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        (section != 0) ? sectionSeparatorHeight : 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: sectionSeparatorHeight))
        view.backgroundColor = .lightGray
        return (section != 0) ? view : UIView()
    }
}

extension UITableViewCell {
    /**
     Sets the text label and the accessory type of the cell according to the option item.
     - Parameter optionItem: The option item to display
     */
    func configure(with optionItem: OptionItem) {
        textLabel?.text = optionItem.text
        textLabel?.font = optionItem.font
        accessoryType = optionItem.isSelected ? .checkmark : .none
    }
    
}

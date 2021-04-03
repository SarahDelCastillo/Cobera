//
//  ProductCell.swift
//  Cobera
//
//  Created by Emilio Del Castillo on 03/04/2021.
//

import UIKit

class ProductCell: UITableViewCell {

    @IBOutlet weak var brandLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var quantityStepper: UIStepper!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func updateQuantity(_ sender: UIStepper){
        if let parent = self.superview as? UITableView {
            let row = parent.indexPath(for: self)!.row
            let newQuantity = Int(sender.value)
            
            quantityLabel.text = "x ".appending(newQuantity.description)
            
            AppData.shared.userItems[row].quantity = newQuantity
            AppData.shared.updateStoredProducts()
        }
        
    }

}

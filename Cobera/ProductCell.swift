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
    
    var currentRow: Int!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func updateQuantity(_ sender: UIStepper){
        
        let newQuantity = Int(sender.value)
        quantityLabel.text = "x ".appending(newQuantity.description)

        AppData.shared.updateQuantity(newQuantity, forRow: currentRow)
        
    }

}

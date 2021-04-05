//
//  OptionItem.swift
//  Popover
//
//  Created by Emilio Del Castillo on 04/04/2021.
//

import UIKit

protocol OptionItem {
    var text: String { get }
    var isSelected: Bool { get set }
    var font: UIFont { get set }
}

extension OptionItem {
    
    /**
     Returns the bounding box of the receiver's text
     */
    func sizeForDisplayText() -> CGSize {
        return text.size(withAttributes: [NSAttributedString.Key.font: font])
    }
}

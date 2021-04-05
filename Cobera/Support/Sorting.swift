//
//  SortingStyles.swift
//  Cobera
//
//  Created by Emilio Del Castillo on 04/04/2021.
//

import UIKit

enum SortingParameter: String {
    case quantity
    case name
}

enum SortingOrder: String {
    case asc
    case desc
}

struct SortingOption: OptionItem {
    // Required variables
    var text: String
    var isSelected: Bool
    var font: UIFont = .preferredFont(forTextStyle: .body)
    
    // Custom variables
    var order: SortingOrder!
    var parameter: SortingParameter!
}

//
//  SortingStyles.swift
//  Cobera
//
//  Created by Emilio Del Castillo on 04/04/2021.
//

import Foundation

enum SortingBy: String, CaseIterable {
    case quantity
    case name
}

enum SortingOrder: String, CaseIterable {
    case asc = "ascending"
    case desc = "descending"
}

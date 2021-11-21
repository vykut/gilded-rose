//
//  File.swift
//  
//
//  Created by vsocaciu on 20.11.2021.
//

import Foundation

enum GildedRoseError: Error {
    case mismatchingItem
    case qualityIsNotPositive
    case cannotAlterLegendaryItemQualityOrSellInValue
    case qualityIsTooBig
    case itemSellInValueIsNotNegative
}

import Foundation

public class GildedRose {
    var items: [Item]
    
    public required init(items:[Item]) {
        self.items = items
    }
    
    // The initial `updateQuality` method had a side-effect inside of it.
    // It was also updating the `sellIn` value of the items
    // For that reason (and also for better readability), the logic from the `updateQuality` method has been broken down into multiple, smaller sub-methods
    
    /// Will proceed to update the `quality` and `sellIn` value for each `item` in the shop
    public func dayHasPassed() {
        items.forEach(updateQualityAndSellIn)
    }
    
    /// Will update the `quality` and `sellIn` value of the `item`
    /// - Parameter item: the `Item` for which the `quality` and `sellIn` should be updated
    func updateQualityAndSellIn(of item: Item) {
        if itemIsNotAgedBrieOrBackstagePassesToConcert(item) {
            try? decreaseQuality(of: item)
            try? decreaseQualityOfConjuredItem(item)
        } else {
            try? increaseQuality(of: item)
            try? increaseQualityOfBackstagePassesToConcert(item: item)
        }
        
        try? updateSellIn(of: item)
        
        try? updateQualityForNegativeSellIn(of: item)
    }

    
    /// Will update the `sellIn` value of the given `item`
    /// - Parameter item: the `Item` for which the `sellIn` value should be updated
    /// - Note: if the `item` is a Legendary item, the `sellIn` will not be updated and an error will be thrown
    func updateSellIn(of item: Item) throws {
        guard item.name != "Sulfuras, Hand of Ragnaros" else {
            throw GildedRoseError.cannotAlterLegendaryItemQualityOrSellInValue
        }
        item.sellIn -= 1
    }
    
    /// Will check whether the `item`'s name matches `Aged Brie` or `Backstage passes to a TAFKAL80ETC concert`
    /// - Parameter item: the `Item` for which to check the name
    /// - Returns: Returns `true` if the `item`'s name matches on of the predicates, otherwise returns `false`
    func itemIsNotAgedBrieOrBackstagePassesToConcert(_ item: Item) -> Bool {
        item.name != "Aged Brie" &&
        item.name != "Backstage passes to a TAFKAL80ETC concert"
    }
    
    /// Will decrease the `quality` of the given `item`
    /// - Parameter item: the `Item` for which the `quality` should be decreased
    /// - Note: if the `item` is a `Backstage passes to a TAFKAL80ETC concert`, then the value will be decreased to 0.
    /// - Note: if the `quality` of the item is already 0, the quality will not be decreased and an error will be thrown
    /// - Note: if the `item` is a Legendary item, the quality will not be altered and an error will be thrown
    func decreaseQuality(of item: Item) throws {
        guard item.quality > 0 else {
            throw GildedRoseError.qualityIsNotPositive
        }
        guard item.name != "Sulfuras, Hand of Ragnaros" else {
            throw GildedRoseError.cannotAlterLegendaryItemQualityOrSellInValue
        }
        if item.name != "Backstage passes to a TAFKAL80ETC concert" {
            item.quality -= 1
        } else {
            item.quality = 0
        }
    }
    
    /// Will increase the `quality` of the given `item`
    /// - Parameter item: the `Item` for which the `quality` should be increased
    /// - Note: if the `quality` of the item is equal to, or bigger than 50, the quality will not be increased and an error will be thrown
    /// - Note: if the `item` is a Legendary item, the quality will not be altered and an error will be thrown
    func increaseQuality(of item: Item) throws {
        guard item.quality < 50 else {
            throw GildedRoseError.qualityIsTooBig
        }
        guard item.name != "Sulfuras, Hand of Ragnaros" else {
            throw GildedRoseError.cannotAlterLegendaryItemQualityOrSellInValue
        }
        item.quality += 1
    }

    /// Will increase the `quality` of the `Backstage passes to a TAFKAL80ETC concert` `item`
    ///
    /// The `Backstage passes to a TAFKAL80ETC concert` is a special `Item` for which the quality increases
    /// when the `sellIn` time nears.
    ///
    /// If the `sellIn` < 11 -> then the `quality` will be increased again by 1
    ///
    /// If the `sellIn` < 6 -> then the `quality` will be increased again by 1
    /// - Parameter item: the `Item` for which the `quality` should be increased
    /// - Note: if the `item` is not `Backstage passes to a TAFKAL80ETC concert`, the quality will not be increased and an error will be thrown
    func increaseQualityOfBackstagePassesToConcert(item: Item) throws {
        guard item.name == "Backstage passes to a TAFKAL80ETC concert" else {
            throw GildedRoseError.mismatchingItem
        }
        if item.sellIn < 11 { try increaseQuality(of: item) }
        if item.sellIn < 6 { try increaseQuality(of: item) }
    }

    
    /// Will update the `quality` of the `item`, if it has a negative `sellIn` value
    ///
    /// The `Aged Brie` if a special `Item`, for which he quality increases the older it becomes
    ///
    /// All the other items will have their `quality` decreased again
    /// - Parameter item: the `Item` for which the quality should be updated
    /// - Note: if the `sellIn` value is not negative, an error will be thrown
    func updateQualityForNegativeSellIn(of item: Item) throws {
        guard item.sellIn < 0 else {
            throw GildedRoseError.itemSellInValueIsNotNegative
        }
        if item.name != "Aged Brie" {
            try decreaseQuality(of: item)
            try? decreaseQualityOfConjuredItem(item)
        } else {
            try increaseQuality(of: item)
        }
    }
    
    /// Will decrease the `quality` of the `item`, if it is Conjured
    ///
    /// Conjured items will decrease in quality even further, if they have a negative `sellIn` value
    /// - Parameter item: the `Item` for which the quality should be decreased
    /// - Note: if the `item` is not Conjured, an error will be thrown
    func decreaseQualityOfConjuredItem(_ item: Item) throws {
        guard item.name.contains("Conjured") else {
            throw GildedRoseError.mismatchingItem
        }
        try decreaseQuality(of: item)
    }
}

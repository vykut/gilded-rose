import Foundation
import XCTest

@testable import GildedRose

class GildedRoseTests: XCTestCase {
    func test_methodUpdateSellIn_afterOneDay_shouldUpdateSellIn() throws {
        let sellIn = 5
        let item = Item(name: "Elixir of the Mongoose", sellIn: sellIn, quality: 7)

        try GildedRose(items: [item]).updateSellIn(of: item)

        XCTAssertEqual(item.sellIn, sellIn - 1)
    }

    func test_methodUpdateSellIn_afterTenDays_shouldUpdateSellIn() throws {
        let sellIn = 5
        let item = Item(name: "Elixir of the Mongoose", sellIn: sellIn, quality: 7)

        for _ in 0 ..< 10 {
            try GildedRose(items: [item]).updateSellIn(of: item)
        }

        XCTAssertEqual(item.sellIn, sellIn - 10)
    }

    func test_methodUpdateSellIn_afterOneDay_forLegendaryItem_shouldNotUpdateSellIn_andThrowError() throws {
        let sellIn = 0
        let item = Item(name: "Sulfuras, Hand of Ragnaros", sellIn: sellIn, quality: 80)

        do {
            try GildedRose(items: [item]).updateSellIn(of: item)
        } catch {
            XCTAssertEqual(error as? GildedRoseError, .cannotAlterLegendaryItemQualityOrSellInValue)
        }

        XCTAssertEqual(item.sellIn, sellIn)
    }

    func test_methodItemIsNotAgedBrieOrBackstagePassesToConcert_forAgedBrieItem_shouldReturnFalse() throws {
        let item = Item(name: "Aged Brie", sellIn: 2, quality: 0)

        let result = GildedRose(items: [item]).itemIsNotAgedBrieOrBackstagePassesToConcert(item)

        XCTAssertEqual(result, false)
    }

    func test_methodItemIsNotAgedBrieOrBackstagePassesToConcert_forBackstagePassesToConcertItem_shouldReturnFalse() throws {
        let item = Item(name: "Backstage passes to a TAFKAL80ETC concert", sellIn: 15, quality: 20)

        let result = GildedRose(items: [item]).itemIsNotAgedBrieOrBackstagePassesToConcert(item)

        XCTAssertEqual(result, false)
    }

    func test_methodItemIsNotAgedBrieOrBackstagePassesToConcert_forItemOtherThanAgedBrieOrBackstagePassesToConcert_shouldReturnTrue() throws {
        let item = Item(name: "Sulfuras, Hand of Ragnaros", sellIn: 0, quality: 80)

        let result = GildedRose(items: [item]).itemIsNotAgedBrieOrBackstagePassesToConcert(item)

        XCTAssertEqual(result, true)
    }

    func test_methodDecreaseQuality_shouldDecreaseQuality() throws {
        let quality = 7
        let item = Item(name: "Elixir of the Mongoose", sellIn: 0, quality: quality)

        try GildedRose(items: [item]).decreaseQuality(of: item)

        XCTAssertEqual(item.quality, quality - 1)
    }

    func test_methodDecreaseQuality_forBackstagePassesToConcertItem_shouldDecreaseQualityToZero() throws {
        let quality = 20
        let item = Item(name: "Backstage passes to a TAFKAL80ETC concert", sellIn: 15, quality: quality)

        try GildedRose(items: [item]).decreaseQuality(of: item)

        XCTAssertEqual(item.quality, 0)
    }

    func test_methodDecreaseQuality_ifQualityIsZero_shouldNotDecreaseQuality_andThrowError() throws {
        let quality = 0
        let item = Item(name: "Elixir of the Mongoose", sellIn: 0, quality: quality)

        do {
            try GildedRose(items: [item]).decreaseQuality(of: item)
        } catch {
            XCTAssertEqual(error as? GildedRoseError, .qualityIsNotPositive)
        }

        XCTAssertEqual(item.quality, quality)
    }

    func test_methodDecreaseQuality_ifQualityIsNegative_shouldNotDecreaseQuality_andThrowError() throws {
        let quality = -3 // Note: In real scenarios, quality should never be negative
        let item = Item(name: "Elixir of the Mongoose", sellIn: 0, quality: quality)

        do {
            try GildedRose(items: [item]).decreaseQuality(of: item)
        } catch {
            XCTAssertEqual(error as? GildedRoseError, .qualityIsNotPositive)
        }

        XCTAssertEqual(item.quality, quality)
    }

    func test_methodDecreaseQuality_forLegendaryItem_shouldNotDecreaseQuality_andThrowError() throws {
        let quality = 80
        let item = Item(name: "Sulfuras, Hand of Ragnaros", sellIn: 0, quality: quality)

        do {
            try GildedRose(items: [item]).decreaseQuality(of: item)
        } catch {
            XCTAssertEqual(error as? GildedRoseError, .cannotAlterLegendaryItemQualityOrSellInValue)
        }

        XCTAssertEqual(item.quality, quality)
    }

    func test_methodDecreaseQualityOfConjuredItem_forConjuredItem_shouldDecreaseQuality() throws {
        let quality = 6
        let item = Item(name: "Conjured Mana Cake", sellIn: 3, quality: quality)

        try GildedRose(items: [item]).decreaseQualityOfConjuredItem(item)

        XCTAssertEqual(item.quality, quality - 1)
    }

    func test_methodDecreaseQualityOfConjuredItem_forItemThatIsNotConjured_shouldNotDecreaseQuality_andThrowError() throws {
        let quality = 6
        let item = Item(name: "Elixir of the Mongoose", sellIn: 0, quality: quality)

        do {
            try GildedRose(items: [item]).decreaseQualityOfConjuredItem(item)
        } catch {
            XCTAssertEqual(error as? GildedRoseError, .mismatchingItem)
        }

        XCTAssertEqual(item.quality, quality)
    }

    func test_methodIncreaseQualityOfBackstagePassesToConcert_forSellInSmallerThanSix_shouldIncreaseQualityTwice() throws {
        let quality = 20
        let item = Item(name: "Backstage passes to a TAFKAL80ETC concert", sellIn: 5, quality: quality)

        try GildedRose(items: [item]).increaseQualityOfBackstagePassesToConcert(item: item)

        XCTAssertEqual(item.quality, quality + 2)
    }

    func test_methodIncreaseQualityOfBackstagePassesToConcert_forSellInSmallerThanEleven_ButBiggerThanSix_shouldIncreaseQuality() throws {
        let quality = 20
        let item = Item(name: "Backstage passes to a TAFKAL80ETC concert", sellIn: 8, quality: quality)

        try GildedRose(items: [item]).increaseQualityOfBackstagePassesToConcert(item: item)

        XCTAssertEqual(item.quality, quality + 1)
    }

    func test_methodIncreaseQualityOfBackstagePassesToConcert_forSellInEqualToEleven_shouldNotIncreaseQuality() throws {
        let quality = 20
        let item = Item(name: "Backstage passes to a TAFKAL80ETC concert", sellIn: 11, quality: quality)

        try GildedRose(items: [item]).increaseQualityOfBackstagePassesToConcert(item: item)

        XCTAssertEqual(item.quality, quality)
    }

    func test_methodIncreaseQualityOfBackstagePassesToConcert_forSellInBiggerThanEleven_shouldNotIncreaseQuality() throws {
        let quality = 20
        let item = Item(name: "Backstage passes to a TAFKAL80ETC concert", sellIn: 23, quality: quality)

        try GildedRose(items: [item]).increaseQualityOfBackstagePassesToConcert(item: item)

        XCTAssertEqual(item.quality, quality)
    }

    func test_methodIncreaseQualityOfBackstagePassesToConcert_forItemOtherThanBackstagePassesToConcert_shouldNotIncreaseQuality_andThrowError() throws {
        let quality = 6
        let item = Item(name: "Elixir of the Mongoose", sellIn: 0, quality: quality)

        do {
            try GildedRose(items: [item]).increaseQualityOfBackstagePassesToConcert(item: item)
        } catch {
            XCTAssertEqual(error as? GildedRoseError, .mismatchingItem)
        }

        XCTAssertEqual(item.quality, quality)
    }

    func test_methodIncreaseQuality_shouldIncreaseQuality() throws {
        let quality = 6
        let item = Item(name: "Elixir of the Mongoose", sellIn: 0, quality: quality)

        try GildedRose(items: [item]).increaseQuality(of: item)

        XCTAssertEqual(item.quality, quality + 1)
    }

    func test_methodIncreaseQuality_forItemWithQualityEqualToFifty_shouldNotIncreaseQuality_andThrowError() throws {
        let quality = 50
        let item = Item(name: "Elixir of the Mongoose", sellIn: 0, quality: quality)

        do {
            try GildedRose(items: [item]).increaseQuality(of: item)
        } catch {
            XCTAssertEqual(error as? GildedRoseError, .qualityIsTooBig)
        }

        XCTAssertEqual(item.quality, quality)
    }

    func test_methodIncreaseQuality_forItemWithQualityBiggerThanFifty_shouldNotIncreaseQuality_andThrowError() throws {
        let quality = 80
        let item = Item(name: "Sulfuras, Hand of Ragnaros", sellIn: 0, quality: quality)

        do {
            try GildedRose(items: [item]).increaseQuality(of: item)
        } catch {
            XCTAssertEqual(error as? GildedRoseError, .qualityIsTooBig)
        }

        XCTAssertEqual(item.quality, quality)
    }

    func test_methodIncreaseQuality_forLegendaryItem_shouldNotIncreaseQuality_andThrowError() throws {
        let quality = 20 // Note: In real scenarios, legendary items will never have a quality different from 80
        let item = Item(name: "Sulfuras, Hand of Ragnaros", sellIn: 0, quality: quality)

        do {
            try GildedRose(items: [item]).increaseQuality(of: item)
        } catch {
            XCTAssertEqual(error as? GildedRoseError, .cannotAlterLegendaryItemQualityOrSellInValue)
        }

        XCTAssertEqual(item.quality, quality)
    }

    func test_methodUpdateQualityForNegativeSellIn_shouldDecreaseQuality() throws {
        let quality = 6
        let item = Item(name: "Elixir of the Mongoose", sellIn: -1, quality: quality)

        try GildedRose(items: [item]).updateQualityForNegativeSellIn(of: item)

        XCTAssertEqual(item.quality, quality - 1)
    }

    func test_methodUpdateQualityForNegativeSellIn_forConjuredItem_shouldDecreaseQualityTwice() throws {
        let quality = 6
        let item = Item(name: "Conjured Mana Cake", sellIn: -1, quality: quality)

        try GildedRose(items: [item]).updateQualityForNegativeSellIn(of: item)

        XCTAssertEqual(item.quality, quality - 2)
    }

    func test_methodUpdateQualityForNegativeSellIn_forAgedBrie_shouldIncreasecreaseQuality() throws {
        let quality = 0
        let item = Item(name: "Aged Brie", sellIn: -1, quality: 0)

        try GildedRose(items: [item]).updateQualityForNegativeSellIn(of: item)

        XCTAssertEqual(item.quality, quality + 1)
    }

    func test_methodUpdateQualityForNegativeSellIn_forZeroSellIn_shouldNotDecreaseQuality_andThrowError() throws {
        let quality = 6
        let item = Item(name: "Elixir of the Mongoose", sellIn: 0, quality: quality)

        do {
            try GildedRose(items: [item]).updateQualityForNegativeSellIn(of: item)
        } catch {
            XCTAssertEqual(error as? GildedRoseError, .itemSellInValueIsNotNegative)
        }

        XCTAssertEqual(item.quality, quality)
    }

    func test_methodUpdateQualityForNegativeSellIn_forPositiveSellIn_shouldNotDecreaseQuality_andThrowError() throws {
        let quality = 6
        let item = Item(name: "Elixir of the Mongoose", sellIn: 2, quality: quality)

        do {
            try GildedRose(items: [item]).updateQualityForNegativeSellIn(of: item)
        } catch {
            XCTAssertEqual(error as? GildedRoseError, .itemSellInValueIsNotNegative)
        }

        XCTAssertEqual(item.quality, quality)
    }

    func test_methodUpdateQualityAndSellIn_shouldDecreaseQualityAndSellIn() throws {
        let sellIn = 3
        let quality = 6
        let item = Item(name: "Elixir of the Mongoose", sellIn: sellIn, quality: quality)

        GildedRose(items: [item]).updateQualityAndSellIn(of: item)

        XCTAssertEqual(item.sellIn, sellIn - 1)
        XCTAssertEqual(item.quality, quality - 1)
    }

    func test_methodUpdateQualityAndSellIn_forAgedBrie_shouldIncreaseQualityAndDecreaseSellIn() throws {
        let sellIn = 3
        let quality = 6
        let item = Item(name: "Aged Brie", sellIn: sellIn, quality: quality)

        GildedRose(items: [item]).updateQualityAndSellIn(of: item)

        XCTAssertEqual(item.sellIn, sellIn - 1)
        XCTAssertEqual(item.quality, quality + 1)
    }

    func test_methodUpdateQualityAndSellIn_forBackstagePassesToConcert_shouldIncreaseQualityAndDecreaseSellIn() throws {
        let sellIn = 23
        let quality = 20
        let item = Item(name: "Backstage passes to a TAFKAL80ETC concert", sellIn: sellIn, quality: quality)

        GildedRose(items: [item]).updateQualityAndSellIn(of: item)

        XCTAssertEqual(item.sellIn, sellIn - 1)
        XCTAssertEqual(item.quality, quality + 1)
    }

    func test_methodUpdateQualityAndSellIn_forNegativeSellIn_shouldDecreaseQualityAndSellIn() throws {
        let sellIn = -1
        let quality = 6
        let item = Item(name: "Elixir of the Mongoose", sellIn: sellIn, quality: quality)

        GildedRose(items: [item]).updateQualityAndSellIn(of: item)

        XCTAssertEqual(item.sellIn, sellIn - 1)
        XCTAssertEqual(item.quality, quality - 2)
    }

    func test_methodUpdateQualityAndSellIn_forNegativeSellIn_forAgedBrie_shouldIncreaseQualityAndDecreaseSellIn() throws {
        let sellIn = -1
        let quality = 6
        let item = Item(name: "Aged Brie", sellIn: sellIn, quality: quality)

        GildedRose(items: [item]).updateQualityAndSellIn(of: item)

        XCTAssertEqual(item.sellIn, sellIn - 1)
        XCTAssertEqual(item.quality, quality + 2)
    }

    func test_methodUpdateQualityAndSellIn_forNegativeSellIn_forBackstagePassesToConcert_shouldIncreaseQualityAndDecreaseSellIn() throws {
        let sellIn = -1
        let quality = 20
        let item = Item(name: "Backstage passes to a TAFKAL80ETC concert", sellIn: sellIn, quality: quality)

        GildedRose(items: [item]).updateQualityAndSellIn(of: item)

        XCTAssertEqual(item.sellIn, sellIn - 1)
        XCTAssertEqual(item.quality, 0)
    }

    func test_methodUpdateQualityAndSellIn_forLegendaryItem_shouldNotAlterQualityNorSellIn() throws {
        let sellIn = 1
        let quality = 80
        let item = Item(name: "Sulfuras, Hand of Ragnaros", sellIn: sellIn, quality: quality)

        GildedRose(items: [item]).updateQualityAndSellIn(of: item)

        XCTAssertEqual(item.sellIn, sellIn)
        XCTAssertEqual(item.quality, quality)
    }

    func test_methodUpdateQualityAndSellIn_forNegativeSellIn_forLegendaryItem_shouldNotAlterQualityNorSellIn() throws {
        let sellIn = -1
        let quality = 80
        let item = Item(name: "Sulfuras, Hand of Ragnaros", sellIn: sellIn, quality: quality)

        GildedRose(items: [item]).updateQualityAndSellIn(of: item)

        XCTAssertEqual(item.sellIn, sellIn)
        XCTAssertEqual(item.quality, quality)
    }

    func test_methodUpdateQualityAndSellIn_forConjuredItem_shouldDecreaseQualityTwiceAndSellIn() throws {
        let sellIn = 1
        let quality = 12
        let item = Item(name: "Conjured Mana Cake", sellIn: sellIn, quality: quality)

        GildedRose(items: [item]).updateQualityAndSellIn(of: item)

        XCTAssertEqual(item.sellIn, sellIn - 1)
        XCTAssertEqual(item.quality, quality - 2)
    }

    func test_methodUpdateQualityAndSellIn_forNegativeSellIn_forConjuredItem_shouldDecreaseQualityFourTimesAndSellIn() throws {
        let sellIn = -1
        let quality = 12
        let item = Item(name: "Conjured Mana Cake", sellIn: sellIn, quality: quality)

        GildedRose(items: [item]).updateQualityAndSellIn(of: item)

        XCTAssertEqual(item.sellIn, sellIn - 1)
        XCTAssertEqual(item.quality, quality - 4)
    }

    func test_methodDayHasPassed_shouldUpdateItemsQualityAndSellIn() throws {
        let items = [
            Item(name: "+5 Dexterity Vest", sellIn: 10, quality: 20), // 0
            Item(name: "Aged Brie", sellIn: 2, quality: 0), // 1
            Item(name: "Elixir of the Mongoose", sellIn: 5, quality: 7), // 2
            Item(name: "Sulfuras, Hand of Ragnaros", sellIn: 0, quality: 80), // 3
            Item(name: "Sulfuras, Hand of Ragnaros", sellIn: -1, quality: 80), // 4
            Item(name: "Backstage passes to a TAFKAL80ETC concert", sellIn: 15, quality: 20), // 5
            Item(name: "Backstage passes to a TAFKAL80ETC concert", sellIn: 10, quality: 49), // 6
            Item(name: "Backstage passes to a TAFKAL80ETC concert", sellIn: 5, quality: 49), // 7
            Item(name: "Conjured Mana Cake", sellIn: 3, quality: 6) // 8
        ]

        GildedRose(items: items).dayHasPassed()

        XCTAssertEqual(items[0].sellIn, 9)
        XCTAssertEqual(items[0].quality, 19)
        XCTAssertEqual(items[1].sellIn, 1)
        XCTAssertEqual(items[1].quality, 1)
        XCTAssertEqual(items[2].sellIn, 4)
        XCTAssertEqual(items[2].quality, 6)
        XCTAssertEqual(items[3].sellIn, 0)
        XCTAssertEqual(items[3].quality, 80)
        XCTAssertEqual(items[4].sellIn, -1)
        XCTAssertEqual(items[4].quality, 80)
        XCTAssertEqual(items[5].sellIn, 14)
        XCTAssertEqual(items[5].quality, 21)
        XCTAssertEqual(items[6].sellIn, 9)
        XCTAssertEqual(items[6].quality, 50)
        XCTAssertEqual(items[7].sellIn, 4)
        XCTAssertEqual(items[7].quality, 50)
        XCTAssertEqual(items[8].sellIn, 2)
        XCTAssertEqual(items[8].quality, 4)
    }

    func test_methodDayHasPassed_afterTenDays_shouldUpdateItemsQualityAndSellIn() throws {
        let items = [
            Item(name: "+5 Dexterity Vest", sellIn: 10, quality: 20), // 0
            Item(name: "Aged Brie", sellIn: 2, quality: 0), // 1
            Item(name: "Elixir of the Mongoose", sellIn: 5, quality: 7), // 2
            Item(name: "Sulfuras, Hand of Ragnaros", sellIn: 0, quality: 80), // 3
            Item(name: "Sulfuras, Hand of Ragnaros", sellIn: -1, quality: 80), // 4
            Item(name: "Backstage passes to a TAFKAL80ETC concert", sellIn: 15, quality: 20), // 5
            Item(name: "Backstage passes to a TAFKAL80ETC concert", sellIn: 10, quality: 49), // 6
            Item(name: "Backstage passes to a TAFKAL80ETC concert", sellIn: 5, quality: 49), // 7
            Item(name: "Conjured Mana Cake", sellIn: 3, quality: 6) // 8
        ]

        for _ in 0 ..< 10 {
            GildedRose(items: items).dayHasPassed()
        }

        XCTAssertEqual(items[0].sellIn, 0)
        XCTAssertEqual(items[0].quality, 10)
        XCTAssertEqual(items[1].sellIn, -8)
        XCTAssertEqual(items[1].quality, 18)
        XCTAssertEqual(items[2].sellIn, -5)
        XCTAssertEqual(items[2].quality, 0)
        XCTAssertEqual(items[3].sellIn, 0)
        XCTAssertEqual(items[3].quality, 80)
        XCTAssertEqual(items[4].sellIn, -1)
        XCTAssertEqual(items[4].quality, 80)
        XCTAssertEqual(items[5].sellIn, 5)
        XCTAssertEqual(items[5].quality, 35)
        XCTAssertEqual(items[6].sellIn, 0)
        XCTAssertEqual(items[6].quality, 50)
        XCTAssertEqual(items[7].sellIn, -5)
        XCTAssertEqual(items[7].quality, 0)
        XCTAssertEqual(items[8].sellIn, -7)
        XCTAssertEqual(items[8].quality, 0)
    }
}

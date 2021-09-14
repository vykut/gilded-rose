package com.gildedrose

data class Item(
    val name: String,
    var sellIn: Int,
    var quality: Int
) {

    @Override
    override fun toString(): String {
        return "$name, $sellIn, $quality"
    }
}
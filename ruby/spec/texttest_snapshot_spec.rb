# frozen_string_literal: true

require File.join(File.dirname(__FILE__), '../gilded_rose')
require 'pry'

items = [
  Item.new('+5 Dexterity Vest', sell_in = 10, quality = 20),
  Item.new('Aged Brie', sell_in = 2, quality = 0),
  Item.new('Elixir of the Mongoose', sell_in = 5, quality = 7),
  Item.new('Sulfuras, Hand of Ragnaros', sell_in = 0, quality = 80),
  Item.new('Sulfuras, Hand of Ragnaros', sell_in = -1, quality = 80),
  Item.new('Backstage passes to a TAFKAL80ETC concert', sell_in = 15, quality = 20),
  Item.new('Backstage passes to a TAFKAL80ETC concert', sell_in = 10, quality = 49),
  Item.new('Backstage passes to a TAFKAL80ETC concert', sell_in = 5, quality = 49),
  # This Conjured item does not work properly yet
  Item.new('Conjured Mana Cake', sell_in = 3, quality = 6) # <-- :O
]

describe GildedRose do
  describe 'capture textfixtures snapshots' do
    it 'does equal texttest_fixture on day 50' do
      gilded_rose = GildedRose.new items
      (0...50).each do |_day|
        gilded_rose.update_quality
      end
      expect(items[0].sell_in).to eq(-40)
      expect(items[0].quality).to eq(0)

      expect(items[1].sell_in).to eq(-48)
      expect(items[1].quality).to eq(50)

      expect(items[2].sell_in).to eq(-45)
      expect(items[2].quality).to eq(0)

      expect(items[3].sell_in).to eq(0)
      expect(items[3].quality).to eq(80)

      expect(items[4].sell_in).to eq(-1)
      expect(items[4].quality).to eq(80)

      expect(items[5].sell_in).to eq(-35)
      expect(items[5].quality).to eq(0)

      expect(items[6].sell_in).to eq(-40)
      expect(items[6].quality).to eq(0)

      expect(items[7].sell_in).to eq(-45)
      expect(items[7].quality).to eq(0)

      expect(items[8].sell_in).to eq(-47)
      expect(items[8].quality).to eq(0)
    end
  end
end

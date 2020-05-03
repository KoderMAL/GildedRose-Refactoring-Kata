# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength
require File.join(File.dirname(__FILE__), '../gilded_rose')
require 'pry'

describe GildedRose do
  describe 'capture existing rules for #update_quality' do
    it 'does not change the name' do
      items = [Item.new('foo', 0, 0)]
      GildedRose.new(items).update_quality
      expect(items[0].name).to eq 'foo'
    end
    it 'does not change quality' do
      items = [Item.new('foo', 0, 0)]
      GildedRose.new(items).update_quality
      expect(items[0].sell_in).to eq(-1)
      expect(items[0].quality).to eq 0
    end
    it 'does never change Sulfuras values' do
      items = [Item.new('Sulfuras, Hand of Ragnaros', 4, 80)]
      days = rand 100 # generates a random number
      (0...days).each do |_|
        GildedRose.new(items).update_quality
        expect(items[0].sell_in).to eq 4
        expect(items[0].quality).to eq 80
      end
    end
    it 'increases quality of Aged Brie' do
      item = Item.new('Aged Brie', 2, 0)
      GildedRose.new([item]).update_quality
      expect(item.quality).to eq(1)
      GildedRose.new([item]).update_quality
      expect(item.quality).to eq(2)
      GildedRose.new([item]).update_quality
      expect(item.quality).to eq(4)
    end
    it 'does decrease quality 2 times faster after sell_in' do
      items = [Item.new('foo', 1, 10)]
      GildedRose.new(items).update_quality
      expect(items[0].quality).to eq 9
      GildedRose.new(items).update_quality
      expect(items[0].quality).to eq 7
    end
    it 'asserts quality is always between 0 and 50' do
      items = [Item.new('Aged Brie', 2, 0), Item.new('foo', 2, 50)]
      60.times { GildedRose.new(items).update_quality }
      expect(items[0].quality).to eq 50
      expect(items[1].quality).to eq 0
    end
    it 'asserts Backstage Passes quality variation behaviour' do
      item = Item.new('Backstage passes to a TAFKAL80ETC concert', sell_in = 11, quality = 20)
      GildedRose.new([item]).update_quality
      expect(item.quality).to eq(21) # more than 10 days left
      GildedRose.new([item]).update_quality
      expect(item.quality).to eq(23) # less than 10 days left
      4.times { GildedRose.new([item]).update_quality }
      expect(item.sell_in).to eq(5) # 5 days left
      expect(item.quality).to eq(31)
      GildedRose.new([item]).update_quality
      expect(item.quality).to eq(34) # less than 5 days left
      4.times { GildedRose.new([item]).update_quality }
      expect(item.quality).to eq(46) # d day
      GildedRose.new([item]).update_quality
      expect(item.quality).to eq(0) # too late!
    end
  end
end
# rubocop:enable Metrics/BlockLength

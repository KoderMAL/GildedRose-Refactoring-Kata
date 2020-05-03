# frozen_string_literal: true

# rubocop:disable Style/IfUnlessModifier

class GildedRose
  def initialize(items)
    @items = items
  end

  def handle_special_items(item)
    return true if item.name == 'Sulfuras, Hand of Ragnaros'

    return aged_brie(item) if item.name == 'Aged Brie'

    return backstage_passes_to_a_tafkal80etc_concert(item) if item.name == 'Backstage passes to a TAFKAL80ETC concert'

    false
  end

  def aged_brie(item)
    if below_max_quality(item)
      item.quality = item.quality + 1
    end
    item.sell_in = item.sell_in - 1
    item.quality = item.quality + 1 if below_max_quality(item) && item.sell_in.negative?
    true
  end

  def backstage_passes_to_a_tafkal80etc_concert(item)
    item.quality = item.quality + 1
    if item.sell_in < 11 && below_max_quality(item)
      item.quality = item.quality + 1
    end
    if item.sell_in < 6 && below_max_quality(item)
      item.quality = item.quality + 1
    end
    item.sell_in = item.sell_in - 1
    item.quality = item.quality - item.quality if item.sell_in.negative?
    true
  end

  def update_quality
    @items.each do |item|
      next if handle_special_items(item)

      item.quality = item.quality - 1 if matches_item_quality_rules(item)
      item.sell_in = item.sell_in - 1
      item.quality = item.quality - 1 if above_min_quality(item) && item.sell_in.negative?
    end
  end

  private

  def below_max_quality(item)
    item.quality < 50
  end

  def above_min_quality(item)
    item.quality > 0
  end

  def matches_item_quality_rules(item)
    below_max_quality(item) && above_min_quality(item)
  end
end

class Item
  attr_accessor :name, :sell_in, :quality

  def initialize(name, sell_in, quality)
    @name = name
    @sell_in = sell_in
    @quality = quality
  end

  def to_s
    "#{@name}, #{@sell_in}, #{@quality}"
  end
end

# rubocop:enable Style/IfUnlessModifier

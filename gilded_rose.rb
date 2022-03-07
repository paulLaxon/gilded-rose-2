# frozen_string_literal: true

# class GildedRose
class GildedRose
  attr_accessor :items

  def initialize(items)
    @items = items
  end

  def update_quality()
    @items.each do |item|
      next if item.name == 'Sulfuras, Hand of Ragnaros'

      item.sell_in -= 1

      update(item)

      item.quality = 0 if item.quality.negative?
      item.quality = 50 if item.quality > 50
    end
  end

  def update(item)
    case item.name
    when 'Aged Brie'
      aged_brie(item)
    when 'Backstage passes to a TAFKAL80ETC concert'
      backstage_passes(item)
    when 'Conjured Mana Cake'
      conjured(item)
    else
      normal(item)
    end
  end

  def aged_brie(item)
    item.quality += 1
  end

  def backstage_passes(item)
    item.quality += 1
    item.quality += 1 if item.sell_in <= 11
    item.quality += 1 if item.sell_in <= 6
    item.quality = 0 if item.sell_in.negative?
  end

  def conjured(item)
    item.quality -= 2
    item.quality -= 2 if item.sell_in.negative?
  end

  def normal(item)
    item.quality -= 1
    item.quality -= 1 if item.sell_in.negative?
  end
end

# class Item
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

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

      if item.name != 'Aged Brie' && item.name != 'Backstage passes to a TAFKAL80ETC concert'
        if item.quality.positive?
          item.quality = if item.name == 'Conjured Mana Cake'
                           item.quality - 2
                         else
                           item.quality - 1
                         end
        end
      elsif item.quality < 50
        item.quality += 1
        if item.name == 'Backstage passes to a TAFKAL80ETC concert'
          if item.sell_in <= 11
            item.quality += 1
          end
          if item.sell_in <= 6
            item.quality += 1
          end
        end
      end
      next unless item.sell_in.negative?

      item.quality += 1 if item.name == 'Aged Brie' && item.quality < 50
      if item.name == 'Backstage passes to a TAFKAL80ETC concert'
        item.quality = 0
      elsif item.quality.positive? && item.name == 'Conjured Mana Cake'
        item.quality -= 2
      else
        item.quality -= 1
      end
    end
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

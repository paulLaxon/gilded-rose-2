require File.join(File.dirname(__FILE__), 'gilded_rose')
require 'byebug'
require 'rspec'

describe GildedRose do
  items = [
    Item.new('+5 Dexterity Vest', 10, 20),
    Item.new('Aged Brie', 2, 0),
    Item.new('Elixir of the Mongoose', 5, 7),
    Item.new('Sulfuras, Hand of Ragnaros', 0, 80),
    Item.new('Sulfuras, Hand of Ragnaros', -1, 80),
    Item.new('Backstage passes to a TAFKAL80ETC concert', 15, 20),
    Item.new('Backstage passes to a TAFKAL80ETC concert', 10, 49),
    Item.new('Backstage passes to a TAFKAL80ETC concert', 5, 49)
    # This Conjured item does not work properly yet
    # Item.new('Conjured Mana Cake', 3, 6)
  ]

  describe '#update_quality' do
    gilded_rose = GildedRose.new items
    byebug
    gilded_rose.update_quality
    it 'does not change the name' do
      items.each_index do |index, item|
        expect(item.name).to eq(items[index].name)
      end
    end
  end
end

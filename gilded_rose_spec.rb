require File.join(File.dirname(__FILE__), 'gilded_rose')
require 'byebug'
require 'rspec'

describe GildedRose do
  items = [
    { name: '+5 Dexterity Vest', sell_in: 1, quality: 20 },
    { name: 'Elixir of the Mongoose', sell_in: 4, quality: 1 },
    { name: 'Aged Brie', sell_in: 2, quality: 0 },
    { name: 'Backstage passes to a TAFKAL80ETC concert', sell_in: 15, quality: 20 },
    { name: 'Backstage passes to a TAFKAL80ETC concert', sell_in: 10, quality: 48 },
    { name: 'Backstage passes to a TAFKAL80ETC concert', sell_in: 1, quality: 44 },
    { name: 'Sulfuras, Hand of Ragnaros', sell_in: 0, quality: 80 },
    { name: 'Sulfuras, Hand of Ragnaros', sell_in: -1, quality: 80 },
    { name: 'Conjured Mana Cake', sell_in: 1, quality: 7 }
  ]

  inventory = []
  items.each do |item|
    inventory.push(Item.new(item[:name], item[:sell_in], item[:quality]))
  end

  gilded_rose = GildedRose.new inventory

  describe '#update_quality' do
    before(:all) do
      gilded_rose.update_quality
    end

    it 'does not change the name' do
      items.each_with_index do |item, index|
        expect(gilded_rose.items[index].name).to eq(item[:name])
      end
    end

    describe 'before the sell in day' do
      it 'subtracts 1 from the sell_in days when name is not Sulfuras' do
        items.each_with_index do |item, index|
          if gilded_rose.items[index].name == 'Sulfuras, Hand of Ragnaros'
            expect(gilded_rose.items[index].sell_in).to eq(item[:sell_in])
          else
            expect(gilded_rose.items[index].sell_in).to eq(item[:sell_in] - 1)
          end
        end
      end

      context 'for normal items' do
        it 'decreases the quality by 1' do
          expect(gilded_rose.items[0].quality).to eq(items[0][:quality] - 1)
          expect(gilded_rose.items[1].quality).to eq(items[1][:quality] - 1)
        end
      end

      context 'for aged brie' do
        it 'increases the quality by 1' do
          expect(gilded_rose.items[2].quality).to eq(items[2][:quality] + 1)
        end
      end

      context 'for backstage passes' do
        it 'increases the quality by 1 when more than 10 days to sell' do
          expect(gilded_rose.items[3].quality).to eq(items[3][:quality] + 1)
        end
        it 'increases the quality by 2 when more than 5 days' do
          expect(gilded_rose.items[4].quality).to eq(items[4][:quality] + 2)
        end
        it 'increases the quality by 1' do
          expect(gilded_rose.items[5].quality).to eq(items[5][:quality] + 3)
        end
      end

      context 'for sulfuras' do
        it 'does not change' do
          expect(gilded_rose.items[6].quality).to eq(items[6][:quality])
          expect(gilded_rose.items[7].quality).to eq(items[7][:quality])
        end
      end
    end

    context 'for conjured items' do
      it 'decreases the quality by 1' do
        expect(gilded_rose.items[8].quality).to eq(items[8][:quality] - 2)
      end
    end
  end

  describe 'after another quality update' do
    context 'when the quality could go over 50' do
      before(:all) do
        gilded_rose.update_quality
      end

      it 'has a maximum quality of 50' do
        expect(gilded_rose.items[4].quality).to eq(50)
      end
    end

    context 'when the sell in date has passed' do
      context 'for normal items' do
        it 'quality is reduced by 2' do
          expect(gilded_rose.items[0].quality).to eq(items[0][:quality] - 3)
        end

        it 'quality cannot be less than 0' do
          expect(gilded_rose.items[1].quality).to eq(0)
        end
      end

      context 'for aged brie' do
        it 'quality increases by 1' do
          expect(gilded_rose.items[2].quality).to eq(items[2][:quality] + 2)
        end
      end

      context 'for backstage passes' do
        it 'quality goes to 0' do
          expect(gilded_rose.items[5].quality).to eq(0)
        end
      end

      context 'for conjured items' do
        it 'quality decreases by 4' do
          expect(gilded_rose.items[8].quality).to eq(items[8][:quality] - 6)
        end
      end
    end
  end
end

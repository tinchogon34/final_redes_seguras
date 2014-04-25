require 'digest/sha2'

class CoordCard < ActiveRecord::Base
  belongs_to :user
  has_many :coord_card_items, dependent: :destroy

  accepts_nested_attributes_for :coord_card_items

  COLS = %w(A B C D E F G H I)
  ROWS = %w(1 2 3 4 5 6 7 8 9)

  def encrypt!
    coord_card_items.each do |coord_card_item|
      coord_card_item.update_attributes value: (Digest::SHA2.new << (coord_card_item.value + coord_card_item.coord_card.user.encrypted_password)).to_s
    end    
  end

  def to_csv(options = {})
    CSV.generate(options) do |csv|
      csv << [""] + COLS
      ROWS.each do |row|
        arr = [row]
        COLS.each do |col|
          arr << coord_card_items.where(coord: col+row).first.value 
        end
        csv << arr
      end
    end
  end

  def self.rand_coord
    COLS.sample + ROWS.sample
  end

  def self.generate!(user)
    coord_card = CoordCard.create user_id: user.id
    COLS.each do |col|
      ROWS.each do |row|
        coord_card_item = CoordCardItem.create coord_card_id: coord_card.id, coord: col + row, value: "#{rand(10)}#{rand(10)}"
      end      
    end
    return coord_card
  end
end

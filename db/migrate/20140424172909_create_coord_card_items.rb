class CreateCoordCardItems < ActiveRecord::Migration
  def change
    create_table :coord_card_items do |t|
      t.references :coord_card, index: true
      t.text :coord
      t.text :value

      t.timestamps
    end
  end
end

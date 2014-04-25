class CreateCoordCards < ActiveRecord::Migration
  def change
    create_table :coord_cards do |t|
      t.references :user, index: true

      t.timestamps
    end
  end
end

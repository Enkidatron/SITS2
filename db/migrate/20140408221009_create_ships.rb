class CreateShips < ActiveRecord::Migration
  def change
    create_table :ships do |t|
      t.string :name
      t.string :ship_class
      t.integer :pivot
      t.integer :roll
      t.text :notes
      t.integer :user_id

      t.timestamps
    end
    add_index :ships, :user_id
  end
end

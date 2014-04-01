class CreateShips < ActiveRecord::Migration
  def change
    create_table :ships do |t|
      t.string :name
      t.string :class
      t.integer :pivot
      t.integer :roll
      t.text :notes

      t.timestamps
    end
  end
end

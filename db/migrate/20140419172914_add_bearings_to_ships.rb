class AddBearingsToShips < ActiveRecord::Migration
  def change
    add_column :ships, :startFront, :string
    add_column :ships, :startTop, :string
    add_column :ships, :midFront, :string
    add_column :ships, :midTop, :string
    add_column :ships, :endFront, :string
    add_column :ships, :endTop, :string
  end
end

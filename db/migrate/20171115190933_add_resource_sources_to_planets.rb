class AddResourceSourcesToPlanets < ActiveRecord::Migration[5.0]
  def change
    add_column :planets, :metal_lvl, :integer, :default => 1
    add_column :planets, :crystal_lvl, :integer, :default => 1
    add_column :planets, :hydrogen_lvl, :integer, :default => nil
    add_column :planets, :solar_lvl, :integer, :default => 1
  end
end

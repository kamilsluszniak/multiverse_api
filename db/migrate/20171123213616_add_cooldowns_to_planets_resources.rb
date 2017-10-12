class AddCooldownsToPlanetsResources < ActiveRecord::Migration[5.0]
  def change
    add_column :planets, :metal_rdy_at, :datetime
    add_column :planets, :crystal_rdy_at, :datetime
    add_column :planets, :hydrogen_rdy_at, :datetime
    add_column :planets, :solar_rdy_at, :datetime
  end
end

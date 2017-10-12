class AddResourcesToPlanets < ActiveRecord::Migration[5.0]
  def change
    add_column :planets, :metal, :bigint
    add_column :planets, :crystal, :bigint
    add_column :planets, :hydrogen, :bigint
    add_column :planets, :energy, :bigint
  end
end

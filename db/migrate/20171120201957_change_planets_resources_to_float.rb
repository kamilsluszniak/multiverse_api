class ChangePlanetsResourcesToFloat < ActiveRecord::Migration[5.0]
  def change
    change_column :planets, :metal, :float
    change_column :planets, :crystal, :float
    change_column :planets, :hydrogen, :float
  end
end

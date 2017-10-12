class AddResourcesUpdatedAtToPlanets < ActiveRecord::Migration[5.0]
  def change
    add_column :planets, :resources_updated_at, :datetime
  end
end

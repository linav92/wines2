class RemoveIsPositionToWinemaker < ActiveRecord::Migration[6.0]
  def change
    remove_column :winemakers, :is_position, :boolean
  end
end

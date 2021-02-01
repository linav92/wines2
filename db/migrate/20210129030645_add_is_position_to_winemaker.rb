class AddIsPositionToWinemaker < ActiveRecord::Migration[6.0]
  def change
    add_column :winemakers, :is_position, :boolean
  end
end

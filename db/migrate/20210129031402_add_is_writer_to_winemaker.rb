class AddIsWriterToWinemaker < ActiveRecord::Migration[6.0]
  def change
    add_column :winemakers, :is_writer, :boolean
  end
end

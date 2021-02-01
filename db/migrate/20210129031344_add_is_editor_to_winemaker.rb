class AddIsEditorToWinemaker < ActiveRecord::Migration[6.0]
  def change
    add_column :winemakers, :is_editor, :boolean
  end
end

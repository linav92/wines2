class CreateWinemakers < ActiveRecord::Migration[6.0]
  def change
    create_table :winemakers do |t|
      t.string :name
      t.integer :old
      t.string :nationality
      t.string :work

      t.timestamps
    end
  end
end

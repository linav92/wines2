class CreateCritics < ActiveRecord::Migration[6.0]
  def change
    create_table :critics do |t|
      t.references :wine, null: false, foreign_key: true
      t.references :winemaker, null: false, foreign_key: true
      t.integer :score

      t.timestamps
    end
  end
end

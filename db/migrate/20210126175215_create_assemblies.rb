class CreateAssemblies < ActiveRecord::Migration[6.0]
  def change
    create_table :assemblies do |t|
      t.references :strain, null: false, foreign_key: true
      t.references :wine, null: false, foreign_key: true
      t.integer :percentage

      t.timestamps
    end
  end
end

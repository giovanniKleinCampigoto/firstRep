class CreateSurvivors < ActiveRecord::Migration[5.0]
  def change
    create_table :survivors do |t|
      t.string :name
      t.integer :age
      t.string :gender
      t.string :lonlat
      t.boolean :infected?

      t.timestamps
    end

    create_table :inventories do |t|
      t.belongs_to :survivor, index: true, unique: true, foreign_key: true
      t.string :name
      t.integer :water
      t.integer :food
      t.integer :medical_kits
      t.integer :ammo

      t.timestamps
    end
  end
end

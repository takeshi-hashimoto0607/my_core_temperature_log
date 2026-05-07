class CreateMenus < ActiveRecord::Migration[7.2]
  def change
    create_table :menus do |t|
      t.string :name, null: false
      t.integer :target_temp, null: false, default: 75

      t.timestamps
    end

    add_index :menus, :name, unique: true
  end
end

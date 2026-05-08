class CreateTemperatureRecords < ActiveRecord::Migration[7.2]
  def change
    create_table :temperature_records do |t|
      t.references :menu, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.integer :temperature, null: false
      t.datetime :measured_at, null: false
      t.integer :set_id
      t.integer :position

      t.timestamps
    end

    add_index :temperature_records, :measured_at
    add_index :temperature_records, :set_id
    add_index :temperature_records, %i[menu_id set_id]
  end
end

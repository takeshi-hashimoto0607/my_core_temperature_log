class AddDayLookupIndexesToTemperatureRecords < ActiveRecord::Migration[7.2]
  def change
    add_index :temperature_records, %i[menu_id measured_at]
    add_index :temperature_records, %i[menu_id measured_at set_id]
  end
end

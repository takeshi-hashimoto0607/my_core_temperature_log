class TemperatureRecord < ApplicationRecord
  belongs_to :menu
  belongs_to :user

  before_validation :assign_set_values, on: :create

  validates :temperature, presence: true, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 0,
    less_than_or_equal_to: 100
  }
  validates :measured_at, presence: true
  validates :set_id, presence: true
  validates :position, presence: true, inclusion: { in: 1..3 }

  private

  def assign_set_values
    return if menu.blank?
    return if measured_at.blank?

    records_on_same_day = TemperatureRecord.where(menu_id: menu_id, measured_at: measured_at.all_day)
    latest_set_id = records_on_same_day.maximum(:set_id)
    records_in_set = latest_set_records(records_on_same_day, latest_set_id)

    self.set_id = next_set_id(latest_set_id, records_in_set)
    self.position = next_position(records_in_set)
  end

  def latest_set_records(records_on_same_day, latest_set_id)
    return TemperatureRecord.none if latest_set_id.blank?

    records = records_on_same_day.where(set_id: latest_set_id)
    records.count < 3 ? records : TemperatureRecord.none
  end

  def next_set_id(latest_set_id, records_in_set)
    return records_in_set.first.set_id if records_in_set.exists?
    return 1 if latest_set_id.blank?

    latest_set_id.to_i + 1
  end

  def next_position(records_in_set)
    records_in_set.count + 1
  end
end

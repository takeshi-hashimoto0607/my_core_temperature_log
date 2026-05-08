class TemperatureRecord < ApplicationRecord
  belongs_to :menu
  belongs_to :user

  validates :temperature, presence: true, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 0,
    less_than_or_equal_to: 100
  }
  validates :measured_at, presence: true
end

class Menu < ApplicationRecord
  has_many :temperature_records, dependent: :restrict_with_error

  before_validation :normalize_name

  validates :name, presence: true, uniqueness: true
  validates :target_temp, presence: true, numericality: { only_integer: true }

  private

  def normalize_name
    self.name = name.to_s.strip
  end
end

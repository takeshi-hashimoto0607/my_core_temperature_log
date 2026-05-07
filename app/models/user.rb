class User < ApplicationRecord
  authenticates_with_sorcery!

  before_validation :normalize_name

  validates :name, presence: true, uniqueness: true
  validates :password, confirmation: true, length: { minimum: 8 }, if: :password_required?
  validates :password_confirmation, presence: true, if: :password_required?

  private

  def normalize_name
    self.name = name.to_s.strip
  end

  def password_required?
    new_record? || password.present?
  end
end

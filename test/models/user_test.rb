require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "is valid with name and virtual password attributes" do
    user = User.new(
      name: "developer",
      password: "password",
      password_confirmation: "password"
    )

    assert user.valid?
  end

  test "requires a unique name" do
    User.create!(
      name: "developer",
      password: "password",
      password_confirmation: "password"
    )

    user = User.new(
      name: "developer",
      password: "password",
      password_confirmation: "password"
    )

    assert_not user.valid?
    assert_includes user.errors[:name], "has already been taken"
  end
end

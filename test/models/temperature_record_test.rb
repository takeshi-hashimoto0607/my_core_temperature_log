require "test_helper"

class TemperatureRecordTest < ActiveSupport::TestCase
  setup do
    @user = User.create!(
      name: "manager",
      password: "password",
      password_confirmation: "password"
    )
    @menu = Menu.create!(name: "昼食")
  end

  test "is valid with required attributes" do
    record = TemperatureRecord.new(
      menu: @menu,
      user: @user,
      temperature: 75,
      measured_at: Time.current
    )

    assert record.valid?
  end

  test "requires temperature" do
    record = TemperatureRecord.new(
      menu: @menu,
      user: @user,
      measured_at: Time.current
    )

    assert_not record.valid?
    assert record.errors.of_kind?(:temperature, :blank)
  end

  test "does not allow temperature less than 0" do
    record = TemperatureRecord.new(
      menu: @menu,
      user: @user,
      temperature: -1,
      measured_at: Time.current
    )

    assert_not record.valid?
  end

  test "does not allow temperature greater than 100" do
    record = TemperatureRecord.new(
      menu: @menu,
      user: @user,
      temperature: 101,
      measured_at: Time.current
    )

    assert_not record.valid?
  end
end

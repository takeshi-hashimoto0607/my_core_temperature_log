require "test_helper"

class TemperatureRecordTest < ActiveSupport::TestCase
  setup do
    @user = User.create!(
      name: "manager",
      password: "password",
      password_confirmation: "password"
    )
    @menu = Menu.create!(name: "野菜炒め")
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

  test "assigns set id and position to first record" do
    record = TemperatureRecord.create!(
      menu: @menu,
      user: @user,
      temperature: 75,
      measured_at: Time.current
    )

    assert_equal 1, record.set_id
    assert_equal 1, record.position
  end

  test "continues same set when same menu is entered consecutively" do
    first_record = TemperatureRecord.create!(
      menu: @menu,
      user: @user,
      temperature: 75,
      measured_at: Time.current
    )
    second_record = TemperatureRecord.create!(
      menu: @menu,
      user: @user,
      temperature: 76,
      measured_at: Time.current
    )

    assert_equal first_record.set_id, second_record.set_id
    assert_equal 2, second_record.position
  end

  test "starts new set after three records" do
    3.times do |i|
      TemperatureRecord.create!(
        menu: @menu,
        user: @user,
        temperature: 75 + i,
        measured_at: Time.current
      )
    end

    fourth_record = TemperatureRecord.create!(
      menu: @menu,
      user: @user,
      temperature: 78,
      measured_at: Time.current
    )

    assert_equal 2, fourth_record.set_id
    assert_equal 1, fourth_record.position
  end

  test "starts new set when different menu is entered" do
    other_menu = Menu.create!(name: "大根の煮物")
    TemperatureRecord.create!(
      menu: @menu,
      user: @user,
      temperature: 75,
      measured_at: Time.current
    )

    record = TemperatureRecord.create!(
      menu: other_menu,
      user: @user,
      temperature: 76,
      measured_at: Time.current
    )

    assert_equal 1, record.set_id
    assert_equal 1, record.position
  end

  test "starts from first set when date changes" do
    TemperatureRecord.create!(
      menu: @menu,
      user: @user,
      temperature: 75,
      measured_at: Time.zone.yesterday
    )

    record = TemperatureRecord.create!(
      menu: @menu,
      user: @user,
      temperature: 76,
      measured_at: Time.current
    )

    assert_equal 1, record.set_id
    assert_equal 1, record.position
  end

  test "requires set id and position" do
    record = TemperatureRecord.create!(
      menu: @menu,
      user: @user,
      temperature: 75,
      measured_at: Time.current
    )

    record.set_id = nil
    record.position = nil

    assert_not record.valid?
    assert record.errors.of_kind?(:set_id, :blank)
    assert record.errors.of_kind?(:position, :blank)
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

require "test_helper"

class MenuTest < ActiveSupport::TestCase
  test "is valid with name and target temp" do
    menu = Menu.new(name: "昼食", target_temp: 75)

    assert menu.valid?
  end

  test "uses default target temp" do
    menu = Menu.create!(name: "昼食")

    assert_equal 75, menu.target_temp
  end

  test "requires a unique name" do
    Menu.create!(name: "昼食")

    menu = Menu.new(name: "昼食")

    assert_not menu.valid?
    assert menu.errors.of_kind?(:name, :taken)
  end
end

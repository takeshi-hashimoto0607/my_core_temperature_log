require "test_helper"

class MenuTest < ActiveSupport::TestCase
  test "is valid with name and target temp" do
    menu = Menu.new(name: "野菜炒め", target_temp: 75)

    assert menu.valid?
  end

  test "uses default target temp" do
    menu = Menu.create!(name: "野菜炒め")

    assert_equal 75, menu.target_temp
  end

  test "requires a unique name" do
    Menu.create!(name: "野菜炒め")

    menu = Menu.new(name: "野菜炒め")

    assert_not menu.valid?
    assert menu.errors.of_kind?(:name, :taken)
  end
end

require "test_helper"

class TemperatureRecordsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(
      name: "manager",
      password: "password",
      password_confirmation: "password"
    )
    @menu = Menu.create!(name: "野菜炒め", target_temp: 75)
  end

  test "redirects to login when not logged in" do
    get new_temperature_record_path

    assert_redirected_to login_path
  end

  test "redirects index to login when not logged in" do
    get temperature_records_path

    assert_redirected_to login_path
  end

  test "redirects print to login when not logged in" do
    get print_temperature_records_path

    assert_redirected_to login_path
  end

  test "shows input page when logged in" do
    login_as(@user)

    get new_temperature_record_path

    assert_response :success
    assert_select "select[name='temperature_record[menu_id]']"
    assert_select "input[name='temperature_record[temperature]'][autofocus]"
    assert_select "form[data-turbo='false']"
  end

  test "shows link to records list on input page" do
    login_as(@user)

    get new_temperature_record_path

    assert_response :success
    assert_select "a", text: "記録一覧を見る"
  end

  test "shows link back to input page on records list" do
    login_as(@user)

    get temperature_records_path

    assert_response :success
    assert_select "a", text: "温度記録入力へ戻る"
  end

  test "shows link to print page on records list" do
    login_as(@user)

    get temperature_records_path

    assert_response :success
    assert_select "a", text: "印刷画面"
  end

  test "shows records by date in chronological order" do
    login_as(@user)
    other_menu = Menu.create!(name: "大根の煮物", target_temp: 75)
    old_record = TemperatureRecord.create!(
      menu: @menu,
      user: @user,
      temperature: 80,
      measured_at: Time.zone.local(2026, 5, 9, 10, 0, 0)
    )
    new_record = TemperatureRecord.create!(
      menu: other_menu,
      user: @user,
      temperature: 82,
      measured_at: Time.zone.local(2026, 5, 9, 11, 0, 0)
    )
    TemperatureRecord.create!(
      menu: @menu,
      user: @user,
      temperature: 78,
      measured_at: Time.zone.local(2026, 5, 10, 10, 0, 0)
    )

    get temperature_records_path, params: { date: "2026-05-09" }

    assert_response :success
    assert_select "td", text: old_record.menu.name
    assert_select "td", text: new_record.menu.name
    assert_select "td", text: "78", count: 0
    assert_match old_record.menu.name, response.body
    assert_operator response.body.index(old_record.menu.name), :<, response.body.index(new_record.menu.name)
  end

  test "shows print page by date" do
    login_as(@user)
    record = TemperatureRecord.create!(
      menu: @menu,
      user: @user,
      temperature: 80,
      measured_at: Time.zone.local(2026, 5, 9, 10, 0, 0)
    )
    TemperatureRecord.create!(
      menu: @menu,
      user: @user,
      temperature: 78,
      measured_at: Time.zone.local(2026, 5, 10, 10, 0, 0)
    )

    get print_temperature_records_path, params: { date: "2026-05-09" }

    assert_response :success
    assert_select "h1", text: "温度記録印刷"
    assert_select "td", text: record.menu.name
    assert_select "td", text: "1セット目"
    assert_select "td", text: "1回目"
    assert_select "td", text: "80"
    assert_select "td", text: @user.name
    assert_select "td", text: "78", count: 0
  end

  test "creates temperature record" do
    login_as(@user)

    assert_difference "TemperatureRecord.count", 1 do
      post temperature_records_path, params: {
        temperature_record: {
          menu_id: @menu.id,
          temperature: 75
        }
      }
    end

    assert_redirected_to new_temperature_record_path(menu_id: @menu.id)
    assert_equal @user, TemperatureRecord.last.user
    assert_equal @menu, TemperatureRecord.last.menu
    assert_equal 1, TemperatureRecord.last.set_id
    assert_equal 1, TemperatureRecord.last.position
  end

  test "shows set id and position in recent records" do
    login_as(@user)
    TemperatureRecord.create!(
      menu: @menu,
      user: @user,
      temperature: 80,
      measured_at: Time.current
    )

    get new_temperature_record_path(menu_id: @menu.id)

    assert_response :success
    assert_select "td", text: "1セット目"
    assert_select "td", text: "1回目"
  end

  test "does not create invalid temperature record" do
    login_as(@user)

    assert_no_difference "TemperatureRecord.count" do
      post temperature_records_path, params: {
        temperature_record: {
          menu_id: @menu.id,
          temperature: 101
        }
      }
    end

    assert_response :unprocessable_entity
  end

  test "redirects to setup when no menu exists" do
    TemperatureRecord.delete_all
    Menu.delete_all
    login_as(@user)

    get new_temperature_record_path

    assert_redirected_to setup_path
  end

  private

  def login_as(user)
    post login_path, params: {
      name: user.name,
      password: "password"
    }
  end
end

require "test_helper"

class ProductionCheckFlowTest < ActionDispatch::IntegrationTest
  test "completes initial setup through print view without seed data" do
    User.delete_all
    Menu.delete_all

    get root_path
    assert_redirected_to new_first_user_setup_path

    get new_first_user_setup_path
    assert_response :success

    post first_user_setup_path, params: {
      user: {
        name: "manager",
        password: "password",
        password_confirmation: "password"
      }
    }
    assert_redirected_to login_path

    post login_path, params: {
      name: "manager",
      password: "password"
    }
    assert_redirected_to setup_path

    post setup_path, params: {
      menu: {
        name: "野菜炒め",
        target_temp: 75
      }
    }
    assert_redirected_to setup_path

    get root_path
    assert_response :success

    post temperature_records_path, params: {
      temperature_record: {
        menu_id: Menu.find_by!(name: "野菜炒め").id,
        temperature: 80
      }
    }
    record = TemperatureRecord.last
    assert_redirected_to new_temperature_record_path(menu_id: record.menu_id)

    get temperature_records_path, params: { date: record.measured_at.to_date.to_s }
    assert_response :success
    assert_select "td", text: "野菜炒め"
    assert_select "td", text: "80"
    assert_select "td", text: "manager"

    get print_temperature_records_path, params: { date: record.measured_at.to_date.to_s }
    assert_response :success
    assert_select "meta[name='viewport']"
    assert_select "h1", text: "温度記録印刷"
    assert_select "td", text: "野菜炒め"
    assert_select "td", text: "1セット目"
    assert_select "td", text: "1回目"
    assert_select "td", text: "80"
    assert_select "td", text: "manager"
  end
end

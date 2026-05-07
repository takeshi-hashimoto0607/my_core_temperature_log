require "test_helper"

class MenusControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(
      name: "manager",
      password: "password",
      password_confirmation: "password"
    )
  end

  test "redirects to login when not logged in" do
    get setup_path

    assert_redirected_to login_path
  end

  test "shows setup page when logged in" do
    login_as(@user)

    get setup_path

    assert_response :success
    assert_select "input[name='menu[name]']"
    assert_select "input[name='menu[target_temp]']"
    assert_select "form[data-turbo='false']"
  end

  test "creates menu" do
    login_as(@user)

    assert_difference "Menu.count", 1 do
      post setup_path, params: {
        menu: {
          name: "昼食",
          target_temp: 75
        }
      }
    end

    assert_redirected_to setup_path
    assert_equal "昼食", Menu.last.name
  end

  test "does not create invalid menu" do
    login_as(@user)

    assert_no_difference "Menu.count" do
      post setup_path, params: {
        menu: {
          name: "",
          target_temp: 75
        }
      }
    end

    assert_response :unprocessable_entity
  end

  private

  def login_as(user)
    post login_path, params: {
      name: user.name,
      password: "password"
    }
  end
end

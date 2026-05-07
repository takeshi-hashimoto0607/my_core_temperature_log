require "test_helper"

class FirstUserSetupsControllerTest < ActionDispatch::IntegrationTest
  setup do
    User.delete_all
  end

  test "shows setup form when no users exist" do
    get new_first_user_setup_path

    assert_response :success
    assert_select "input[name='user[name]']"
    assert_select "input[name='user[password]']"
    assert_select "input[name='user[password_confirmation]']"
  end

  test "creates first user and redirects to login" do
    assert_difference "User.count", 1 do
      post first_user_setup_path, params: {
        user: {
          name: "manager",
          password: "password",
          password_confirmation: "password"
        }
      }
    end

    assert_redirected_to login_path
    assert_equal "manager", User.last.name
  end

  test "does not create user with invalid params" do
    assert_no_difference "User.count" do
      post first_user_setup_path, params: {
        user: {
          name: "",
          password: "password",
          password_confirmation: "different"
        }
      }
    end

    assert_response :unprocessable_entity
  end

  test "redirects to login when a user exists" do
    User.create!(
      name: "manager",
      password: "password",
      password_confirmation: "password"
    )

    get new_first_user_setup_path

    assert_redirected_to login_path
  end
end

require "test_helper"

class InitialSetupFlowTest < ActionDispatch::IntegrationTest
  test "redirects to first user setup when no users exist" do
    User.delete_all

    get root_path

    assert_redirected_to new_first_user_setup_path
  end

  test "allows first user setup when no users exist" do
    User.delete_all

    get new_first_user_setup_path

    assert_response :success
  end

  test "redirects to login when user exists and visitor is not logged in" do
    User.create!(
      name: "manager",
      password: "password",
      password_confirmation: "password"
    )

    get root_path

    assert_redirected_to login_path
  end

  test "allows access when logged in" do
    user = User.create!(
      name: "manager",
      password: "password",
      password_confirmation: "password"
    )
    Menu.create!(name: "昼食")

    post login_path, params: {
      name: user.name,
      password: "password"
    }

    get root_path

    assert_response :success
  end
end

require "test_helper"

class UserSessionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(
      name: "manager",
      password: "password",
      password_confirmation: "password"
    )
  end

  test "shows login form" do
    get login_path

    assert_response :success
    assert_select "input[name='name']"
    assert_select "input[name='password']"
    assert_select "form[data-turbo='false']"
  end

  test "logs in with name and password" do
    post login_path, params: {
      name: @user.name,
      password: "password"
    }

    assert_redirected_to root_path
    assert_equal @user.id.to_s, session[:user_id]
  end

  test "strips name before login" do
    post login_path, params: {
      name: " #{@user.name} ",
      password: "password"
    }

    assert_redirected_to root_path
    assert_equal @user.id.to_s, session[:user_id]
  end

  test "does not log in with invalid password" do
    post login_path, params: {
      name: @user.name,
      password: "wrong-password"
    }

    assert_response :unprocessable_entity
    assert_nil session[:user_id]
  end

  test "logs out" do
    post login_path, params: {
      name: @user.name,
      password: "password"
    }

    delete logout_path

    assert_redirected_to root_path
    assert_nil session[:user_id]
  end

  test "redirects to root when logged in user accesses login form" do
    post login_path, params: {
      name: @user.name,
      password: "password"
    }

    get login_path

    assert_redirected_to root_path
  end
end

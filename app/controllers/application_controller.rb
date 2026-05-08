class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  add_flash_types :success, :danger

  before_action :redirect_to_first_user_setup
  before_action :require_login

  private

  def redirect_to_first_user_setup
    return if User.exists?
    return if controller_path == "first_user_setups"

    redirect_to new_first_user_setup_path
  end

  def require_login
    redirect_to login_path, danger: t("defaults.flash_message.require_login") unless logged_in?
  end
end

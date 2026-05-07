class FirstUserSetupsController < ApplicationController
  before_action :redirect_if_user_exists

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to "/login", success: t(".success")
    else
      flash.now[:danger] = t(".failure")
      render :new, status: :unprocessable_entity
    end
  end

  private

  def redirect_if_user_exists
    redirect_to "/login" if User.exists?
  end

  def user_params
    params.require(:user).permit(:name, :password, :password_confirmation)
  end
end

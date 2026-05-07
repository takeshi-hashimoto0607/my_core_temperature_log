class UserSessionsController < ApplicationController
  before_action :redirect_if_logged_in, only: :new

  def new; end

  def create
    if login(params[:name].to_s.strip, params[:password])
      redirect_to root_path, success: t(".success")
    else
      flash.now[:danger] = t(".failure")
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    logout
    redirect_to root_path, status: :see_other, success: t(".success")
  end

  private

  def redirect_if_logged_in
    redirect_to root_path if logged_in?
  end
end

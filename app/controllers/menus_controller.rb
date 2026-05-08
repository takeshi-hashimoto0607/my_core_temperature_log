class MenusController < ApplicationController
  def index
    @menu = Menu.new(target_temp: 75)
    @menus = Menu.order(:name)
  end

  def create
    @menu = Menu.new(menu_params)

    if @menu.save
      redirect_to setup_path, success: t(".success")
    else
      @menus = Menu.order(:name)
      flash.now[:danger] = t(".failure")
      render :index, status: :unprocessable_entity
    end
  end

  private

  def menu_params
    params.require(:menu).permit(:name, :target_temp)
  end
end

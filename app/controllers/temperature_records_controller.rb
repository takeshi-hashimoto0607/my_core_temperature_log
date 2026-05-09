class TemperatureRecordsController < ApplicationController
  before_action :redirect_to_setup_if_no_menu
  before_action :set_menus

  def index
    @date = selected_date
    @temperature_records = TemperatureRecord.includes(:menu, :user)
                                            .where(measured_at: @date.all_day)
                                            .order(:measured_at, :id)
  end

  def new
    @temperature_record = TemperatureRecord.new(menu: selected_menu)
    set_recent_records
  end

  def create
    @temperature_record = current_user.temperature_records.new(temperature_record_params)
    @temperature_record.measured_at = Time.current

    if @temperature_record.save
      redirect_to new_temperature_record_path(menu_id: @temperature_record.menu_id), success: t(".success")
    else
      set_recent_records
      flash.now[:danger] = t(".failure")
      render :new, status: :unprocessable_entity
    end
  end

  private

  def redirect_to_setup_if_no_menu
    redirect_to setup_path if Menu.none?
  end

  def set_menus
    @menus = Menu.order(:name)
  end

  def selected_menu
    Menu.find_by(id: params[:menu_id] || params.dig(:temperature_record, :menu_id)) || Menu.first
  end

  def set_recent_records
    @selected_menu = selected_menu
    @recent_records = TemperatureRecord.includes(:menu, :user)
                                       .where(menu: @selected_menu)
                                       .order(measured_at: :desc)
                                       .limit(3)
  end

  def selected_date
    params[:date].present? ? Date.parse(params[:date]) : Date.current
  rescue ArgumentError
    Date.current
  end

  def temperature_record_params
    params.require(:temperature_record).permit(:menu_id, :temperature)
  end
end

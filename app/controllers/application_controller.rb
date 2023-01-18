class ApplicationController < ActionController::Base
  helper_method :holiday_service

  def holiday_service
    HolidayService.new
  end
end

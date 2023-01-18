require 'httparty'
require 'json'

class HolidayService
  def initialize
    @repo_data = get_parsed_data("https://date.nager.at/api/v3/NextPublicHolidays/us")
  end

  def get_parsed_data(url)
    parse(get_data(url))
  end

  def get_data(url)
    HTTParty.get(url)
  end

  def parse(data)
    JSON.parse(data.body)
  end

  def next_3_holidays
    @repo_data[0..2]
  end

  def names_and_date
    next_3_holidays.each do |h|
      h[:name]
      h[:date]
    end
  end
end
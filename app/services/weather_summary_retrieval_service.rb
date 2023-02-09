require 'net/http'

# this service class accepts a latitude, longitude pair OR postal_code and calls WeatherAPI's forecast API to retrieve a weather summary for the location 
# the response is a WeatherSummary object which includes current weather and forecast data
#
# if a postal_code is provided, the response is cached for 30 minutes
class WeatherSummaryRetrievalService
  def initialize(latitude: nil, longitude: nil, postal_code: nil)
    @latitude = latitude
    @longitude = longitude
    @postal_code = postal_code
  end

  attr_reader :postal_code
  
  def retrieve_weather_summary_via_weather_api
    return cached_weather_summary if cached_weather_summary
    raise "missing WEATHER_API_KEY.  follow README setup instructions to insure .env file contains the proper keys" if api_key_missing?

    uri = URI(weather_api_url_with_query)
    response_json = Net::HTTP.get_response(uri).body

    weather_summary = WeatherSummary.new.from_weather_api_response(response_json: response_json)
    Rails.cache.write(postal_code, weather_summary, expires_in: 30.minutes) if postal_code
    
    weather_summary
  end

  private

  attr_reader :latitude, :longitude

  def cached_weather_summary
    @cached_weather_summary ||= begin
      return nil unless postal_code

      Rails.cache.read(postal_code)
    end
  end

  def weather_api_url_with_query
    base_url = "http://api.weatherapi.com/v1/forecast.json?"
    query_params = {
      q: postal_code ? postal_code : "#{latitude},#{longitude}",
      key: api_key,
      days: 7,
      aqi: "no",
      alerts: "no"
    }
    base_url + query_params.to_query
  end

  def api_key
    @api_key ||= ENV["WEATHER_API_KEY"]
  end

  def api_key_missing?
    api_key.blank? || (ENV["WEATHER_API_KEY"] == "replace-me-with-real-api-key")
  end
end
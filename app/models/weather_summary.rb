class WeatherSummary
  # parses weather API forecast response and returns OpenStruct object with a weather summary
  # including the current weather and 7 day forcast of the form:
  # {
  #   location: {
  #     timezone:
  #   }
  #   current: {
  #     temperature_farenheit:,
  #     condition_icon_url
  #   },
  #   forecast: [
  #     {
  #       date_epoch:,
  #       min_temperature_farenheit:,
  #       max_temperature_farenheit:,
  #       condition_icon_url:
  #     },
  #     ...
  #   ]
  # }
  #
  # sample response: https://www.weatherapi.com/api-explorer.aspx#forecast
  def from_weather_api_response(response_json:)
    result = JSON.parse(response_json).with_indifferent_access
    location = result[:location]

    raise "weather summary could not be retrieved" unless location

    current = result[:current]
    all_forecast_data = result[:forecast][:forecastday]
    desired_forecast_data = all_forecast_data.map do |forecast_day|
      daily_values = forecast_day[:day]
      OpenStruct.new(
        date_epoch: forecast_day[:date_epoch],
        min_temperature_farenheit: daily_values[:mintemp_f],
        max_temperature_farenheit: daily_values[:maxtemp_f],
        condition_icon_url: daily_values[:condition][:icon]
      )
    end

    OpenStruct.new(
      location: OpenStruct.new(
        timezone: location.dig(:tz_id)
      ),
      current: OpenStruct.new(
        temperature_farenheit: current.dig(:temp_f),
        condition_icon_url: current.dig(:condition, :icon)
      ),
      forecast: desired_forecast_data
    )
  end
end
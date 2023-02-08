require "rails_helper"

describe WeatherSummary do
  subject = described_class.new

  describe "#from_weather_api_response" do
    context "valid request" do
      let(:response) { File.read('spec/stubs/weather_api/response_for_successful_request.json') }

      it "returns a WeatherSummary with correclty parsed latitude, longitude, and postal_code" do
        weather_summary = subject.from_weather_api_response(response_json: response)

        location = weather_summary.location
        current = weather_summary.current
        forecast = weather_summary.forecast
        first_forecast_day = forecast.first

        expect(location.timezone).to eq("America/Los_Angeles")
        expect(current.temperature_farenheit).to eq(57.2)
        expect(current.condition_icon_url).to eq("//cdn.weatherapi.com/weather/64x64/day/113.png")
        expect(forecast.size).to eq(7)
        expect(first_forecast_day.date_epoch).to eq(1675814400)
        expect(first_forecast_day.min_temperature_farenheit).to eq(39.9)
        expect(first_forecast_day.max_temperature_farenheit).to eq(65.7)
        expect(first_forecast_day.condition_icon_url).to eq("//cdn.weatherapi.com/weather/64x64/day/113.png")
      end
    end

    context "invalid request" do
      let(:response) { File.read('spec/stubs/weather_api/response_for_invalid_request.json') }

      it "throws an error" do
        expect{subject.from_weather_api_response(response_json: response)}.to raise_error("weather summary could not be retrieved")
      end
    end
  end
end
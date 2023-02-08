require "rails_helper"
require 'net/http'

describe WeatherSummaryRetrievalService do
  subject { described_class.new(latitude: latitude, longitude: longitude, postal_code: postal_code) }

  let(:latitude) { 37.4223878 }
  let(:longitude) { -122.0841877 }
  let(:postal_code) { 94043 }

  let(:weather_api_response_body) { File.read("spec/stubs/weather_api/response_for_successful_request.json") }
  let(:weather_api_url) do
    URI(
      "http://api.weatherapi.com/v1/forecast.json?alerts=no&aqi=no&days=7&key=#{ENV['WEATHER_API_KEY']}&q=#{query_param}"
    )
  end

  describe "#retrieve_weather_summary_via_weather_api" do
    before do
      # stub weather api
      weather_api_response = Net::HTTPSuccess.new(1.0, '200', 'OK')
      expect(Net::HTTP).to receive(:get_response).with(weather_api_url) { weather_api_response }
      expect(weather_api_response).to receive(:body) { weather_api_response_body }
    end

    context "when postal_code IS provided" do
      let(:query_param) {postal_code}

      it "calls the Weather API with the POSTAL CODE and returns the expected WeatherSummary" do
        weather_summary = subject.retrieve_weather_summary_via_weather_api

        expect(weather_summary.current.temperature_farenheit).to eq(57.2)
        expect(weather_summary.forecast.size).to eq(7)
      end
    end

    context "when postal_code is NOT provided" do
      let(:postal_code) { nil }
      let(:query_param) {"#{latitude}%2C#{longitude}"}

      it "calls the Weather API with LATITUDE & LONGITUDE and returns the expected WeatherSummary" do
        weather_summary = subject.retrieve_weather_summary_via_weather_api

        expect(weather_summary.current.temperature_farenheit).to eq(57.2)
        expect(weather_summary.forecast.size).to eq(7)
      end
    end
  end
end

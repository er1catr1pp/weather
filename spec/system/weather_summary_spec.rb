require "rails_helper"

RSpec.describe "Weather Summary" do
  let(:address) { "1600 Amphitheatre Pkwy, Mountain View, CA" }
  let(:google_geocoding_api_response_body) { File.read("spec/stubs/google_geocoding_api/response_with_postal_code.json") }
  let(:weather_api_response_body) { File.read("spec/stubs/weather_api/response_for_successful_request.json") }
  let(:google_geocoding_api_url) do
    URI(
      "https://maps.googleapis.com/maps/api/geocode/json?address=1600+Amphitheatre+Pkwy%2C+Mountain+View%2C+CA&key=#{ENV['GOOGLE_GEOCODING_API_KEY']}"
    )
  end
  let(:weather_api_url) do
    URI(
      "http://api.weatherapi.com/v1/forecast.json?alerts=no&aqi=no&days=7&key=#{ENV['WEATHER_API_KEY']}&q=94043"
    )
  end

  before do
    # stub google geocoding api
    google_geocoding_response = Net::HTTPSuccess.new(1.0, '200', 'OK')
    expect(Net::HTTP).to receive(:get_response).with(google_geocoding_api_url) { google_geocoding_response }
    expect(google_geocoding_response).to receive(:body) { google_geocoding_api_response_body }
    
    # stub weather api
    weather_api_response = Net::HTTPSuccess.new(1.0, '200', 'OK')
    expect(Net::HTTP).to receive(:get_response).with(weather_api_url) { weather_api_response }
    expect(weather_api_response).to receive(:body) { weather_api_response_body }
  end

  context "retrieving a weather summary" do
    it "redirects to a summary of the weather when provided with a valid address" do
      visit root_path

      expect(page).to have_content("Enter an address or postal code to get a summary of the weather:")
      
      fill_in "address", with: address
      click_button 'submit'

      expect(page).to have_link("Back")
      expect(page).to have_content(address)
      expect(page).to have_current_path(weather_summaries_path(address: address))
    end
  end

  context "weather summary content" do
    it "shows the current weather" do
      visit weather_summaries_path(address: address)

      expect(page).to have_content("Current Weather")
      expect(page).to have_content("57.2 (F)")
    end

    it "shows a 7 day forecast with highs and lows" do
      visit weather_summaries_path(address: address)

      expect(page).to have_content("7 Day Forecast")
      
      expect(page).to have_content("Wed High: 65.7 (F) Low: 39.9 (F)")
      expect(page).to have_content("Thu High: 70.7 (F) Low: 38.1 (F)")
      expect(page).to have_content("Fri High: 57.9 (F) Low: 34.3 (F)")
      expect(page).to have_content("Sat High: 52.3 (F) Low: 40.3 (F)")
      expect(page).to have_content("Sun High: 65.7 (F) Low: 37.2 (F)")
      expect(page).to have_content("Mon High: 66.2 (F) Low: 41.9 (F)")
      expect(page).to have_content("Tue High: 57.4 (F) Low: 37.6 (F)")
    end

    it "indicates whether or not the weather summary was retrieved from the cache" do
      visit weather_summaries_path(address: address)

      expect(page).to have_content("Cached: false")
    end
  end
end

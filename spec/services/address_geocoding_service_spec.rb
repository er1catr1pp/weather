require "rails_helper"
require 'net/http'

describe AddressGeocodingService do
  subject { described_class.new(address: address) }

  describe "#geocode_via_google_geocoding_api" do
    let(:address) { "1600 Amphitheatre Pkwy, Mountain View, CA" }
    let(:google_geocoding_api_response_body) { File.read("spec/stubs/google_geocoding_api/response_with_postal_code.json") }
    let(:expected_url) do
      URI(
        "https://maps.googleapis.com/maps/api/geocode/json?address=1600+Amphitheatre+Pkwy%2C+Mountain+View%2C+CA&key=#{ENV['GOOGLE_GEOCODING_API_KEY']}"
      )
    end

    it "calls the Google Geocoding API with the expected URL and returns the expected GeocodedAddress" do
      response = Net::HTTPSuccess.new(1.0, '200', 'OK')
      expect(Net::HTTP).to receive(:get_response).with(expected_url) { response }
      expect(response).to receive(:body) { google_geocoding_api_response_body }    
    
      geocoded_address = subject.geocode_via_google_geocoding_api

      expect(geocoded_address.latitude).to eq(37.4223878)
      expect(geocoded_address.longitude).to eq(-122.0841877)
      expect(geocoded_address.postal_code).to eq("94043")
    end
  end
end
require "rails_helper"

describe GeocodedAddress do
  subject = described_class.new

  describe "#from_google_geocoding_api_response" do
    context "valid request" do
      context "the response DOES contain postal_code data" do
        let(:response) { File.read('spec/stubs/google_geocoding_api/response_with_postal_code.json') }

        it "returns a GeocodedAddress with correclty parsed latitude, longitude, and postal_code" do
          geocoded_address = subject.from_google_geocoding_api_response(response_json: response)

          expect(geocoded_address.latitude).to eq(37.4223878)
          expect(geocoded_address.longitude).to eq(-122.0841877)
          expect(geocoded_address.postal_code).to eq("94043")
        end
      end

      context "the response does NOT contain postal_code data" do
        let(:response) { File.read('spec/stubs/google_geocoding_api/response_without_postal_code.json') }

        it "returns a GeocodedAddress with correctly parsed latitude and longitude but NO postal_code" do
          geocoded_address = subject.from_google_geocoding_api_response(response_json: response)
          
          expect(geocoded_address.latitude).to eq(37.4223878)
          expect(geocoded_address.longitude).to eq(-122.0841877)
          expect(geocoded_address.postal_code).to be_nil
        end
      end
    end

    context "invalid request" do
      let(:response) { File.read('spec/stubs/google_geocoding_api/response_for_invalid_request.json') }

      it "throws an error" do
        expect{subject.from_google_geocoding_api_response(response_json: response)}.to raise_error("address could not be geocoded")
      end
    end
  end
end
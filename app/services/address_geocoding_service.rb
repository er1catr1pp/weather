require 'net/http'

# this service class accepts an address string and calls Google Geocoding API to geocode the address 
# the response is a GeocodedAddress object which includes latitude, longitude, and zipcode
class AddressGeocodingService
  def initialize(address:)
    @address = address
  end
  
  def geocode_via_google_geocoding_api
    raise "missing GOOGLE_GEOCODING_API_KEY.  follow README setup instructions to insure .env file contains the proper keys" if api_key_missing?

    uri = URI(google_geocoding_api_url_with_query)
    response_json = Net::HTTP.get_response(uri).body

    GeocodedAddress.new.from_google_geocoding_api_response(response_json: response_json)
  end

  private

  attr_reader :address

  def google_geocoding_api_url_with_query
    base_url = "https://maps.googleapis.com/maps/api/geocode/json?"
    query_params = {
      address: address,
      key: ENV["GOOGLE_GEOCODING_API_KEY"]
    }
    base_url + query_params.to_query
  end

  def api_key
    @api_key ||= ENV["GOOGLE_GEOCODING_API_KEY"]
  end

  def api_key_missing?
    api_key.blank? || (ENV["GOOGLE_GEOCODING_API_KEY"] == "replace-me-with-real-api-key")
  end
end
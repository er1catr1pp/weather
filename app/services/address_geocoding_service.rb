require 'net/http'

# this service class accepts an address string and calls Google Geocoding API to geocode the address 
# the response is a GeocodedAddress object which includes latitude, longitude, and zipcode
class AddressGeocodingService
  def initialize(address:)
    @address = address
  end
  
  def geocode_via_google_geocoding_api
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
end
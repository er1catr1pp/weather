class GeocodedAddress
  # parses google geocoding API response and returns OpenStruct object with:
  # latitude (required)
  # longitude (required)
  # postal_code (optional)
  #
  # sample response: https://developers.google.com/maps/documentation/geocoding/requests-geocoding
  def from_google_geocoding_api_response(response_json:)
    result = JSON.parse(response_json).with_indifferent_access[:results].first

    raise "address could not be geocoded" unless result

    location = result.dig(:geometry, :location)
    postal_code_address_component = result[:address_components].detect do |address_component|
      address_component[:types].include?("postal_code")
    end
    OpenStruct.new(
      latitude: location[:lat],
      longitude: location[:lng],
      postal_code: postal_code_address_component ? postal_code_address_component[:long_name] : nil
    )
  end
end
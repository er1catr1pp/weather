class WeatherSummariesController < ApplicationController
  def new
  end

  def create
    redirect_to action: 'index', address: address_param
  end

  def index
    @address = address_param
    @weather_summary_is_from_cache = cached_weather_summary ? true : false
    @weather_summary = weather_summary
  end

  private

  def weather_summary
    return cached_weather_summary if cached_weather_summary

    WeatherSummaryRetrievalService.new(
      latitude: geocoded_address.latitude,
      longitude: geocoded_address.longitude,
      postal_code: geocoded_address.postal_code
    ).retrieve_weather_summary_via_weather_api
  end

  def geocoded_address
    @geocoded_address ||= AddressGeocodingService.new(address: address_param).geocode_via_google_geocoding_api
  end

  def cached_weather_summary
    @cached_weather_summary ||= begin
      # if the address provided is a postal code, we can look for a cached response without calling the geocoding API
      return Rails.cache.read(address_param) if address_is_postal_code?

      # otherwise, we need to call the geocoding API and then look in the cache for the returned postal code
      return Rails.cache.read(geocoded_address.postal_code) if geocoded_address.postal_code

      nil
    end
  end

  def address_is_postal_code?
    # NOTE: this method could be improved to match all supported postal code formats (e.g. US zipcodes with dashes, UK postal codes, etc.)
    # for now, it matches any string that consists only of digits 0-9
    address_param !~ /\D/
  end

  def address_param
    @address_param ||= params.require(:address)
  end
end
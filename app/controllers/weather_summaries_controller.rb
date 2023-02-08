class WeatherSummariesController < ApplicationController
  def new
  end

  def create
    redirect_to action: 'index', address: address_param
  end

  def index
    @weather_summary = AddressGeocodingService.new(address: address_param).geocode_via_google_geocoding_api
  end

  private

  def address_param
    params.require(:address)
  end
end
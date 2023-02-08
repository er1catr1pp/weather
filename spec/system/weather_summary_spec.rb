require "rails_helper"

RSpec.describe "Weather Summary" do
  let(:address) { "1600 Amphitheatre Pkwy, Mountain View, CA" }
  let(:google_geocoding_api_response_body) { File.read("spec/stubs/google_geocoding_api/response_with_postal_code.json") }

  it "displays a summary of the weather when provided with an address" do
    response = Net::HTTPSuccess.new(1.0, '200', 'OK')
    expect(Net::HTTP).to receive(:get_response) { response }
    expect(response).to receive(:body) { google_geocoding_api_response_body }
    
    visit root_path

    expect(page).to have_content("Enter an address or postal code to get a summary of the weather:")
    
    fill_in "address", with: address
    click_button 'submit'

    expect(page).to have_link("Back")
    expect(page).to have_content("latitude=37.4223878")
  end
end

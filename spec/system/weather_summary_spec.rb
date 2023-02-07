require "rails_helper"

RSpec.describe "Weather Summary" do
  it "displays the current weather" do
    visit root_path

    expect(page).to have_content("sunny & beautiful")
  end
end

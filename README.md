# README

Please see `SOLUTION.md` for documentation detailing how I approached the coding assignment, specifics of the implemented solution, and assumptions made along the way.

# Weather

A simple Rails weather app:

- When provided with an address or zipcode as input, the app retrieves and displays a weather summary for the location, including current weather and a 7 day forecast.  

- Google Geocoding API is used for geociding addresses, and WeatherAPI is used for retrieving weather data.

## System Requirements
- Ruby 3.2.0
- Rails 7.0.4
- Bundler

## Setup

**IMPORTANT**: The app requires a `.env` file with valid API keys for the two third party APIs.  For purposes of the assignment, valid keys were provided separately.

Follow the setup instructions below to set up API keys, install requirements, and run the app:

1. Clone this repo
2. `cd` into the project root
3. Create a local `.env` file with the required API keys
   1. `mv .env.example .env`
   2. Replace the placholder text with valid API keys (provided separately) for:
      1. GOOGLE_GEOCODING_API_KEY
      2. WEATHER_API_KEY
4. Run `bundle install`
5. Ensure that the test suite is passing:
   1. `rspec spec`
6. Run the application:
   1. `rails s`
7. The app should be visible in the browser at `localhost:3000`

## Test Suite

The application uses RSpec for testing.
- Tests are located in the `/spec` folder
- To run the test suite, use the following command:
   - `rspec spec`
# Intro

Thank you for inviting me to do the coding assignment!

This document details the presented solution for the coding assignment, including:
 - Specifics of the solution
 - Technical design decisions
 - Assumptions
 - Scalability considerations

## Solution

The presented solution is standard rails 7 application which:
1. accepts an address or postal code as input location
2. geocodes the address if necessary
3. retrieves weather data for the location
4. displays a weather summary for the provided location including
   - current weather with temperature, conditions, and local time at the input location
   - 7 day forecast weather with highs, lows, and conditions
5. caches weather summary data for 30 minutes if a postal code can be determined for the location

RSpec unit tests are provided for testing business logic, and system specs are provided for testing user flows and UI.

## Technical Design Decisions

### **Testing**
RSpec & Capybara were chosen for testing as they are straight-forward to implement and extensible to large scale production applications.  

Unit tests & system specs are included to test business logic, user flows, and some UI components.  In a larger production environment, the addition of UI specific testing would be valuable to ensure that the proper UI elements are present, validate that style and formatting are correct, and protect against visual regression.

### **Third Party APIs**
Google Geocoding API and Weather API's forecast API were chosen for this application due to ease of use and cost.  There are several other combinations of third party APIs that could satisfy the requirements of this assignment.  

In a large scale produciton application, it would be important to insure that third party APIs were properly evaluated for functionality, ease of use, cost, security, scalability, reliability, etc.

### **Caching Strategy**

The standard Rails cache with a provided ttl of 30 minutes is used for caching weather data by zip code.

If a zip code is either provided as input or available in the geocoded address retrieved from the third party API, associated weather data is cached by zip code for 30 minutes.

When handling input, the following steps are taken:
- If the input is a zip code
   - If the Rails cache contains weather data for that zip code
      - Return the cached data
   - Otherwise
      - Call the Weather API with the input zipcode
         - Cache the returned weather data for the zipcode
         - Return the weather data
- Otherwise (the input is an address string)
   - Call the Geocoding API to geocode the address and get the associated zip code
     - If the Rails cache contains weather data for that zip code
        - Return the cached data
     - Otherwise
        - Call the Weather API with the input zipcode
        - Cache the returned weather data for the zipcode
        - Return the weather data

### **UI**
The application uses standard erb rails views with minimal inline styling for the UI.  Using a more modern front-end (e.g. react) and leveraging a styling framework could definitely improve the user experience.  

That said, it would be imporant to insure the team was comfortable with any additional technology and that the required frameworks were well supported in test and production environments.

### **Security**

`dotenv-rails` is used to manage API keys for the applicaiton.  This prevents the security risk of checking in sensitive data to version control.  It also provides a single location (the `.env` file) from which to manage the applications environment variables, secrets, and API keys.

### **Data Storage**

There is no persistent data storage for the application and no underlying database.  All weather data is either temporarily stored in the Rails cache or is retrieved directly from the third party APIs.  

## Assumptions

- The assignment stated that an address should be accepted as input.  It also stated that the cache should handle "subsequent requests by zip codes".  As such, I made the assumption that the input should support full address strings as well as standard zip codes.  Additionally, I made the assumption that the when an address is provided without a zip code, the weather results should be cached by the associated geocoded zip code if one can be determined.

- I made the assumption that minimal styling and visual design were required for the assignment and that mock-ups & design requirements would be provided under normal circumstances.

## Scalability Considerations

If the app were to be scaled to support a high traffic production environment, a few considerations come to mind:
- Third party APIs may need to be re-assessed for reliability, scalability, and cost
- Different caching infrastructure (e.g. redis) could make the app more robust
- A more sophisticated caching strategy could improve latency and overall performance.  For example, weather summary data could be cached by address for popular addresses that do not have associated postal codes.
- Adding a visual testing framework could help maintain a stable UI and protect against visual regression
- Using a more modern front-end framework and spending time UI design could provide a more effective & efficient user experience
 
*** Settings ***
Library     Browser
Library     String

*** Variables ***
${GO_FOOD_URL}                          https://gofood.co.id/
${LOCATION}                             Ashta
${FULL_LOCATION_NAME}                   Ashta District 8
${LOCATION_SELECTOR}                    //input[@placeholder="Enter your location"]
${FULL_LOCATION_SELECTOR}               //p[text()='${FULL_LOCATION_NAME}']
${EXPLORE_BUTTON}                       //span[text()='Explore']
${NEAR_ME_SECTION}                      //h3[@title='Near me']
${BEST_SELLERS_SECTION}                 //h3[@title='Best sellers']
${DISTANCE_TEXT_ON_RESTAURANT_CARDS}    //*[@id="__next"]/div/div[3]/div[1]/a/div/div[2]/div[2]
${SEARCH_BUTTON}                        //a[@href="/en/search"]
${SEARCH_INPUT}                         //input[@id="search-query"]
${SEARCH_RESULT}                        //p[text()='Sec Bowl, Cikajang']
${BUDGET_MEAL_SELECTOR}                 //h3[@title='Budget meal']
${MOST_LOVED_SELECTOR}                  //h3[@title='Most loved']
${HOURS_24_SELECTOR}                    //h3[@title='24 hours']
${HEALTHY_FOOD_SELECTOR}                //h3[@title='Healthy food']
${PASTI_ADA_PROMO_SELECTOR}             //h3[@title='Pasti Ada Promo']
${RESTO_RATING_TEXT_ON_RESTO_CARDS}     //*[@id="__next"]/div/div[3]/div[1]/a/div/div[1]/div[2]/div

*** Test Cases ***
Scenario: Explore GoFood by location and filter restaurants by proximity and rating
    [Documentation]    Go To gofood.co.id -> select location : use your current location
    Given I open GoFood website
    When I enter location and confirm selection
    Then I should see different food categories
    And I filter by restaurants near me
    And I filter by best-selling restaurants
    And I search for a specific restaurant

*** Keywords ***
I open GoFood website
    New Browser  chromium    headless=No
    New Page     ${GO_FOOD_URL}

I enter location and confirm selection
    Type Text    ${LOCATION_SELECTOR}    ${LOCATION}
    Sleep        2s
    Wait For Elements State  ${FULL_LOCATION_SELECTOR}  visible  timeout=10s
    Click        ${FULL_LOCATION_SELECTOR}
    Click        ${EXPLORE_BUTTON}

I should see different food categories
    Wait For Elements State    ${NEAR_ME_SECTION}             visible
    Wait For Elements State    ${BEST_SELLERS_SECTION}        visible
    Wait For Elements State    ${BUDGET_MEAL_SELECTOR}        visible
    Wait For Elements State    ${MOST_LOVED_SELECTOR}         visible
    Wait For Elements State    ${HOURS_24_SELECTOR}           visible
    Wait For Elements State    ${HEALTHY_FOOD_SELECTOR}       visible
    Wait For Elements State    ${PASTI_ADA_PROMO_SELECTOR}    visible

I filter by restaurants near me
    Click    ${NEAR_ME_SECTION}
    @{RESTO_CARDS}    Get Elements    ${DISTANCE_TEXT_ON_RESTAURANT_CARDS}
    FOR  ${RESTO}  IN  @{RESTO_CARDS}
        ${RESTO_DISTANCE}  Get Text  ${RESTO}
        ${DISTANCE_STR}    Fetch From Left    ${RESTO_DISTANCE}    km
        ${DISTANCE_STR}    Strip String    ${DISTANCE_STR}
        ${DISTANCE}        Convert To Number    ${DISTANCE_STR}
        Should Be True     ${DISTANCE} <= 0.5    Distance ${DISTANCE} km exceeds maximum 0.5 km
    END

I filter by best-selling restaurants
    Go Back
    Click  ${BEST_SELLERS_SECTION}
    @{RESTO_CARDS}    Get Elements    ${RESTO_RATING_TEXT_ON_RESTO_CARDS}
    FOR  ${RESTO}  IN  @{RESTO_CARDS}
        ${RESTO_RATING}  Get Text  ${RESTO}
        Should Be True     ${RESTO_RATING} >= 4.3    Rating ${RESTO_RATING} below minimum 4.6
    END

I search for a specific restaurant
    Go Back
    Wait For Elements State  ${SEARCH_BUTTON}    visible
    Click    ${SEARCH_BUTTON}
    Type Text    ${SEARCH_INPUT}    Secbowl
    Click    ${SEARCH_RESULT}
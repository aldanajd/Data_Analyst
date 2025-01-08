URL = "https://store.steampowered.com/specials"

GAMES_CLASS_NAME = "ImpressionTrackedElement"

MAIN_CONTAINER_CLASS_NAME = "SaleSectionForCustomCSS" # Item[2]

TABS_XPATH = "//div[contains(@class, 'Focusable') and @tabindex='0' and text()]"

REVIEWS = [
    "Overwhelmingly Positive"
    , "Very Positive"
    , "Mostly Positive"
    , "Mixed"
    , "Mostly Negative"
    , "Very Negative"
    , "Overwhelmingly Negative"
]

DATA_DICT = {
"Name" : []
, "Reviews" : []
, "Reviews_Count" : []
, "Discount" : []
, "Original_Price" : []
, "Discounted_Price" : []
}

DF_DICT = {}
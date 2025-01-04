from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from webdriver_manager.chrome import ChromeDriverManager
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.common.by import By 
from selenium.common.exceptions import ElementClickInterceptedException

import pandas as pd
import time

# CONSTANTS
URL = "https://store.steampowered.com/specials"
GAMES_CLASS_NAME = "ImpressionTrackedElement"
MAIN_CLASS_NAME = "SaleSectionForCustomCSS" # 2
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

SERVICE = Service(ChromeDriverManager().install())
DRIVER = webdriver.Chrome(service=SERVICE)

# Navigate to the desired URL
DRIVER.get(URL)
time.sleep(5) 

# Extracting the BODY of the Website
BODY = DRIVER.find_element(By.TAG_NAME, "body")
time.sleep(5)

# Extracting the Main Container (Tabs and Games)
MAIN_CONTAINER = DRIVER.find_elements(By.CLASS_NAME, MAIN_CLASS_NAME)[2]
time.sleep(5)

TABS_CONTAINER = None

# Extracting the TABs (Top Sellers, New & Trending, etc...)
while not TABS_CONTAINER:
    # Scroll Down if TABS_CONTAINER is not found yet
    BODY.send_keys(Keys.PAGE_DOWN)
    time.sleep(2)
    TABS_CONTAINER = DRIVER.find_elements(By.XPATH, TABS_XPATH)
    time.sleep(2)

# Iterate Over Every TAB to Get the Games Data
for tab in TABS_CONTAINER:
    while True:
        try:
            # Click the TAB Element to Render the Games Inside said TAB
            DRIVER.execute_script("arguments[0].click();", tab)
            break
        except ElementClickInterceptedException:
            print(f"Scrolling Up to Find {tab} Element")
            # Scroll Up if TAB Element is not found yet
            tab.send_keys(Keys.PAGE_UP)
            time.sleep(5)  
    time.sleep(5)

    # Extracting the Games Data
    GAMES_CONTAINER = MAIN_CONTAINER.find_elements(By.CLASS_NAME, GAMES_CLASS_NAME)
    time.sleep(5)

    # Iterate Over Every Game
    for game_container in GAMES_CONTAINER:
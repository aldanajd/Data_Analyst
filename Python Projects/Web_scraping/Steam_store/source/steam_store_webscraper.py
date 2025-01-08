import pandas as pd
import time

from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from webdriver_manager.chrome import ChromeDriverManager
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.common.by import By 
from selenium.common.exceptions import ElementClickInterceptedException

from functions import *
from constants import *

pd.set_option('display.colheader_justify', 'center')

# Installing the Chrome Driver
SERVICE = Service(ChromeDriverManager().install())

# Setting it up
DRIVER = webdriver.Chrome(service=SERVICE)

# Navigate to the desired URL
DRIVER.get(URL)
time.sleep(5)

# Extracting the BODY of the Website
BODY = DRIVER.find_element(By.TAG_NAME, "body")
time.sleep(5)

# Extracting the Main Container (Tabs and Games)
MAIN_CONTAINER = DRIVER.find_elements(By.CLASS_NAME, MAIN_CONTAINER_CLASS_NAME)[2]
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
    container_splitter(GAMES_CONTAINER)
    reset_dictionary(DATA_DICT)

    # Iterating over every game
    for game_container in GAMES_CONTAINER:
        
        DATA_DICT["Name"].append(game_container[0])

        # Iterating over every string inside the game container
        reviews = [string for string in game_container if string in REVIEWS]
        reviews = list_to_string(reviews)
        DATA_DICT["Reviews"].append(reviews)
        
        reviews_count = [string for string in game_container if "User Reviews" in string]
        reviews_count = list_to_string(reviews_count)
        DATA_DICT["Reviews_Count"].append(reviews_count)
        
        discount = [string for string in game_container if string.endswith("%")]  
        discount = list_to_string(discount)
        DATA_DICT["Discount"].append(discount)

        price = [game_string for game_string in game_container if game_string.startswith("$")]
        
        # Price can be defined as two (original, discounted)        
        if price:
            DATA_DICT["Original_Price"].append(price[0])
            if len(price)>1:
                DATA_DICT["Discounted_Price"].append(price[1]) 
            else:
                DATA_DICT["Discounted_Price"].append("")           
        # If there is no price, append "Coming Soon"
        else:
            DATA_DICT["Original_Price"].append("Coming Soon")
            DATA_DICT["Discounted_Price"].append("")

    DF_DICT[tab.text] = pd.DataFrame.from_dict(DATA_DICT)

for key,value in DF_DICT.items():
    print(f"\n************************************** TAB: {key} **************************************")
    print(f"{value}")
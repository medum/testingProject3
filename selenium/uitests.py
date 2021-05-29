# #!/usr/bin/env python
from selenium import webdriver
from selenium.webdriver.chrome.options import Options as ChromeOptions
import datetime
import time


def timestamp():
    ts = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    return (ts + '\t')


# Start the browser and login with standard_user
def login(user, password):
    print(timestamp() + 'Starting the browser...')
    options = ChromeOptions()
    options.add_argument('--no-sandbox')
    options.add_argument("--headless")
    driver = webdriver.Chrome(executable_path='C:\Azure\security\chromedriver.exe')
    print(timestamp() + 'Browser started successfully. Navigating to the demo page to login.')
    driver.get('https://www.saucedemo.com/')
    # login
    driver.find_element_by_css_selector("input[id='user-name']").send_keys(user)
    driver.find_element_by_css_selector("input[id='password']").send_keys(password)
    driver.find_element_by_id("login-button").click()
    product_label = driver.find_element_by_class_name("title").text
    print(product_label)
    assert "PRODUCTS" in product_label
    print(timestamp() + 'Login with username {:s} and password {:s} successfully.'.format(user, password))
    return driver


def add_cart(driver, n_items):

    # driver.find_element_by_id("item_"+str(n_items)+"_title_link").click()
    for i in range(n_items):
        time.sleep(5)
        element = driver.find_element_by_id("item_" + str(i) + "_title_link").text
        cart_id = str((str(element).lower()).replace(" " , "-"))
        print("add-to-cart-"+str(cart_id).lower())
        print(type(cart_id))
        # print(driver.find_element_by_id(str(cart_id)))
        driver.find_element_by_id("add-to-cart-"+cart_id).click()

    # product = driver.find_element_by_class_name("inventory_details_name").text  # Get the name of the product from the page
    # print(timestamp() + product + " added to shopping cart.")  # Display message saying which product was added
    # driver.find_element_by_css_selector("button.inventory_details_back_button").click()
    # for i in range(n_items):
    #     time.sleep(5)
    #     # print(driver.find_element_by_id("item_"+str(i)+"_title_link").get_attribute("text"))
    #     element = driver.find_element_by_id("item_" + str(i) + "_title_link").get_attribute("text")
    #     # str(element).replace(" ", "-")
    #     # driver.find_element_by_id("item_" + str(i) + "_title_link").click()
    #     time.sleep(5)
    #     driver.find_element_by_id("add-to-cart-" + str(str(element).replace(" ", "-"))).submit()
             # Click the Back button
    print(timestamp() + '{:d} items are all added to shopping cart successfully.'.format(n_items))


def remove_cart(driver, n_items):
    for i in range(n_items):
        time.sleep(5)
        element = driver.find_element_by_id("item_" + str(i) + "_title_link").text
        cart_id = str((str(element).lower()).replace(" ", "-"))
        print("add-to-cart-" + str(cart_id).lower())
        print(type(cart_id))
        # print(driver.find_element_by_id(str(cart_id)))
        driver.find_element_by_id("remove-" + cart_id).click()
    print(timestamp() + '{:d} items are all removed from shopping cart successfully.'.format(n_items))


if __name__ == "__main__":
    N_ITEMS = 4
    TEST_USERNAME = 'standard_user'
    TEST_PASSWORD = 'secret_sauce'
    driver = login("standard_user", "secret_sauce")
    add_cart(driver, N_ITEMS)
    remove_cart(driver, N_ITEMS)
    print(timestamp() + 'Selenium tests are all successfully completed!')
    driver.quit()

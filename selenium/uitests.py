import datetime
import sys
import time
from _ast import Assert

from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.remote.webelement import WebElement
original_stdout = sys.stdout
def timestamp():
    ts = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    return (ts + '\t')
with open('filename.txt', 'w') as f:
    sys.stdout = f
    driver = webdriver.Chrome(executable_path='pathto\chromedriver.exe')
    print(timestamp() + 'opening Amazon web site...')
    driver.get("https://www.amazon.com/")
    search_box = driver.find_element_by_id('twotabsearchtextbox')
    print(timestamp() + 'searching for clue board game.')
    search_box.send_keys("clue board game");
    search_box.submit()
    # results = driver.find_element(By.XPATH, "//div[@class='a-section a-spacing-small a-spacing-top-smalla-section a-spacing-small a-spacing-top-small']")
    # print(results);
    product = driver.find_element_by_link_text("Clue Game")
    product.click();
    time.sleep(5)
    print(timestamp() + 'Adding to cart.')
    addToCart = driver.find_element_by_id("submit.add-to-cart-announce")
    addToCart.submit();
    time.sleep(5)
    id = driver.find_element_by_id("ap_email")
    id.send_keys("email@gmail.com")
    driver.find_element_by_id("continue").submit()
    driver.find_element_by_id("ap_password").send_keys("password")
    driver.find_element_by_id("signInSubmit").submit()
    print(timestamp() + 'items in cart :')
    print(driver.find_element_by_id("nav-cart-count").text)
    driver.find_element_by_id("nav-cart-count").click()
    time.sleep(5)
    print(timestamp() + ' Deleting items in cart :')
    driver.find_element(By.CSS_SELECTOR, "[aria-label='Delete Clue Game']").click()

    print(timestamp() + ' items in cart  after deleting:')
    print(driver.find_element_by_id("nav-cart-count").text)
    driver.quit()
    sys.stdout = original_stdout

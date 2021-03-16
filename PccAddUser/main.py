from selenium import webdriver

PROXY = "127.0.0.1:9000"
webdriver.DesiredCapabilities.FIREFOX['proxy'] = {
    "httpProxy": PROXY,
    "ftpProxy": PROXY,
    "sslProxy": PROXY,
    "proxyType": "MANUAL",

}

with webdriver.Firefox() as driver:
    # Open URL
    driver.get("https://172.17.2.242:9999/gui/login")

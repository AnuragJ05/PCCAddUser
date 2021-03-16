*** Settings ***
Library        SeleniumLibrary


*** Variables ***
${url}      https://172.17.2.242:9999/gui/login
${browser}      firefox
*** Test Cases ***

LoginTest
    open browser        ${url}      ${browser}
    input text    xpath:/html/body/div/div[2]/div/div[2]/div/form/div[1]/input      admin
    input text    name:password     admin
    click element     xpath:/html/body/div/div[2]/div/div[2]/div/form/button
    close browser

*** Keywords ***

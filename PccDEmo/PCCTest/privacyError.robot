*** Settings ***
Library        SeleniumLibrary


*** Variables ***
${url}      https://172.17.2.242:9999/gui/login
${browser}      chrome
*** Test Cases ***

LoginTest
    open browser        ${url}      ${browser}
    maximize browser window
    #automate privacy error page
    ${titleOfPage}=      get window titles
    #Log     title value is ${titleOfPage}
    run keyword if      ${titleOfPage} == ['Privacy error']     privacy error page
    #close browser

*** Keywords ***

privacy error page
    click element       id:details-button
    click element       id:proceed-link

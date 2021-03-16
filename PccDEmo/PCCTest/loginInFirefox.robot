*** Settings ***
Library        SeleniumLibrary


*** Variables ***
${url}      https://172.17.2.242:9999/gui/login
${browser}      firefox
*** Test Cases ***

LoginTest
    open browser        ${url}      ${browser}
    maximize browser window

    #automate privacy error page
    ${titleOfPage}=      get window titles
    #Log     title value is ${titleOfPage}
    run keyword if      ${titleOfPage} == ['Warning: Potential Security Risk Ahead']     privacy error page

    #login to gui
    input text    xpath:/html/body/div/div[2]/div/div[2]/div/form/div[1]/input      admin
    input text    name:password     admin
    click element     xpath:/html/body/div/div[2]/div/div[2]/div/form/button

    close browser


*** Keywords ***

privacy error page
    click element       id:advancedButton
    click element       id:exceptionDialogButton



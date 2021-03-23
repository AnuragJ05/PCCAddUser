*** Settings ***
Library        SeleniumLibrary
Library         ImapLibrary2
Suite Setup     open firefox with proxy
Suite Teardown      close browser


*** Variables ***
${url}      https://172.17.2.242:9999/gui/login
${browser}      firefox
${mailId}       <mail id>
${mailPass}     <mail password>
${pccNotificationMailId}        pcc_notifications@platinasystems.com
${newUserPass}      calsoft
${adminPass}      admin
${adminUserName}      admin
${passwordLink}

*** Test Cases ***

LoginTest
    #automate privacy error page
    ${titleOfPage}=      get window titles
    #Log     title value is ${titleOfPage}
    run keyword if      ${titleOfPage} == ['Warning: Potential Security Risk Ahead']     privacy error page

    #login to gui
    input text    xpath://*[@class="login-form"]//input[@class="form-control "]      ${adminUserName}
    input text    xpath://*[@class="login-form"]//input[@class="form-control"]     ${adminPass}
    click element     xpath://*[@class="btn-block btn btn-primary"]
    Sleep  4s

CreateTenants
    Wait Until Element Is Visible       xpath://a[starts-with(@href, '/gui/tenants')]
    click element       xpath://a[starts-with(@href, '/gui/tenants')]

    Wait Until Element Is Visible    xpath://*[@class="pcc-icon pcc-add-icon undefined pcc-icon--active undefined"]
    click element       xpath://*[@class="pcc-icon pcc-add-icon undefined pcc-icon--active undefined"]

    Wait Until Page Contains        Add Tenant
    input text    xpath://*[@class="modal-body"]//input[@name="name"]      tenant6

    #select Parent
    #click element       xpath://*[@class="css-1hwfws3"]
    #click element       xpath://*[contains(text(),'ROOT')]
    #Sleep  2s
    #Press Keys      None       ENTER
    Sleep  2s


    Wait Until Element Is Visible       xpath://*[@class="create-button btn btn-primary"]
    click element       xpath://*[@class="create-button btn btn-primary"]
    #close browser

*** Keywords ***

privacy error page
    click element       id:advancedButton
    click element       id:exceptionDialogButton

open firefox without proxy
    ${profile}=   Evaluate   sys.modules['selenium.webdriver'].FirefoxProfile()  sys
    Create WebDriver   Firefox   firefox_profile=${profile}
	maximize browser window
	Go To    ${url}

open firefox with proxy
	${profile}=   Evaluate   sys.modules['selenium.webdriver'].FirefoxProfile()  sys
	Call Method   ${profile}   set_preference   network.proxy.socks   127.0.0.1
	Call Method   ${profile}   set_preference   network.proxy.socks_port  ${9000}
	Call Method   ${profile}   set_preference   network.proxy.socks_remote_dns  ${True}
	Call Method   ${profile}   set_preference   network.proxy.type   ${1}
	Create WebDriver   Firefox   firefox_profile=${profile}
	maximize browser window
	Go To    ${url}
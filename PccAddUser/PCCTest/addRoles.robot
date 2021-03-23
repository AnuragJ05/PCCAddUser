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
${roleName}     readOnly
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

AddRoles
    #Set Selenium Speed 	0.5 seconds
    Wait Until Element Is Visible       xpath://a[starts-with(@href, '/gui/roles')]
    click element       xpath://a[starts-with(@href, '/gui/roles')]

    Sleep  5s

    Wait Until Element Is Visible    xpath://*[@class="pcc-icon pcc-add-icon undefined pcc-icon--active undefined"]
    click element       xpath://*[@class="pcc-icon pcc-add-icon undefined pcc-icon--active undefined"]

    Wait Until Page Contains        Add Role
    input text    xpath://*[@class="modal-body"]//input[@name="name"]      ${roleName}

    Sleep  2s


    click element       xpath://*[@class="css-10nd86i"]

    click element       xpath:(//*[contains(text(),'tenant6')])[2]

    Wait Until Page Contains        Service Management

    select radio button     groupOperations.0.value     1
    select radio button     groupOperations.1.value     3
    select radio button     groupOperations.2.value     5
    select radio button     groupOperations.3.value     7
    select radio button     groupOperations.4.value     9

    Wait Until Element Is Enabled       xpath://*[@class="create-button btn btn-primary"]
    click element       xpath://*[@class="create-button btn btn-primary"]

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

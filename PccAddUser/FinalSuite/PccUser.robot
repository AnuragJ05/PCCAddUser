*** Settings ***
Library        SeleniumLibrary
Library         ImapLibrary2
Suite Setup     open firefox with proxy
Suite Teardown      close browser


*** Variables ***
${url}      https://172.17.2.242:9999/gui/login
${browser}      firefox
${adminUserMailId}       platinasystems@gmail.com
${adminUserMailPass}        plat1n@!
${adminUserFName}       platina
${adminUserLName}       systems
${ReadOnlyUserMailId}       calsoftplatina@gmail.com
${ReadOnlyUserMailPass}     plat1n@!
${ReadOnlyUserFName}       calsoft
${ReadOnlyUserLName}       platina
${pccNotificationMailId}        pcc_notifications@platinasystems.com
${newUserPass}      calsoft
${adminPass}      admin
${adminUserName}      admin
${roleName}     readOnly
${passwordLink}

*** Test Cases ***

Create Tenants and Roles
        LoginTest
        CreateTenants
        AddRoles

Adding Admin User
        AddUser admin         ${adminUserFName}       ${adminUserLName}       ${adminUserMailId}
        OpenMail        ${adminUserMailId}      ${adminUserMailPass}
        SetPassword        ${passwordLink}      ${newUserPass}
        LoginWithNewUser        ${adminUserMailId}     ${newUserPass}
        LogOutCurrentUser
        LoginToAdmin         ${adminUserName}        ${adminPass}

Adding ReadOnly User
        AddUser readOnly         ${ReadOnlyUserFName}       ${ReadOnlyUserLName}       ${ReadOnlyUserMailId}
        OpenMail        ${ReadOnlyUserMailId}      ${ReadOnlyUserMailPass}
        SetPassword        ${passwordLink}      ${newUserPass}
        LoginWithNewUser        ${ReadOnlyUserMailId}     ${newUserPass}
        LogOutCurrentUser
        LoginToAdmin         ${adminUserName}        ${adminPass}

Delete All Users
        DeleteAllUser

Delete All Tenants
        DeleteAllTenants


*** Keywords ***
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
    Sleep  2s

    Wait Until Element Is Visible       xpath://*[@class="create-button btn btn-primary"]
    click element       xpath://*[@class="create-button btn btn-primary"]
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
    Sleep  4s


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


AddUser readOnly
    [Arguments]     ${FName}        ${LName}        ${mailId}
    Wait Until Element Is Visible    xpath://a[starts-with(@href, '/gui/users')]
    click element       xpath://a[starts-with(@href, '/gui/users')]

    Wait Until Element Is Visible    xpath://*[@class="pcc-icon pcc-add-icon undefined pcc-icon--active undefined"]
    click element       xpath://*[@class="pcc-icon pcc-add-icon undefined pcc-icon--active undefined"]

    #add user details
    #Sleep  2s
    input text    xpath://*[@class="modal-body"]//input[@name="firstname"]      ${FName}
    input text    xpath://*[@class="modal-body"]//input[@name="lastname"]      ${LName}
    input text    xpath://*[@class="modal-body"]//input[@name="username"]      ${mailId}

    #select tenant
    click element       xpath://*[@class="form-group"][4]/*[@class="css-10nd86i"]
    Sleep  2s
    click element       xpath://*[contains(text(),'tenant6')]
    #Sleep  2s
    #Press Keys      None       ENTER
    Sleep  2s

    #select user role
    click element       xpath://*[@class="form-group"][5]/*[@class="css-10nd86i"]
    Sleep  2s
    click element       xpath://*[contains(text(),'ADMIN (tenant6)')]
    #Sleep  2s
    #Press Keys      None       ENTER
    Sleep  2s

    Wait Until Element Is Visible       xpath://*[@class="create-button btn btn-primary"]
    click element       xpath://*[@class="create-button btn btn-primary"]
    #close browser
    Sleep  10s

AddUser admin
    [Arguments]     ${FName}        ${LName}        ${mailId}
    Wait Until Element Is Visible    xpath://a[starts-with(@href, '/gui/users')]
    click element       xpath://a[starts-with(@href, '/gui/users')]

    Wait Until Element Is Visible    xpath://*[@class="pcc-icon pcc-add-icon undefined pcc-icon--active undefined"]
    click element       xpath://*[@class="pcc-icon pcc-add-icon undefined pcc-icon--active undefined"]

    #add user details
    #Sleep  2s
    input text    xpath://*[@class="modal-body"]//input[@name="firstname"]      ${FName}
    input text    xpath://*[@class="modal-body"]//input[@name="lastname"]      ${LName}
    input text    xpath://*[@class="modal-body"]//input[@name="username"]      ${mailId}

    #select tenant
    click element       xpath://*[@class="form-group"][4]/*[@class="css-10nd86i"]
    #click element       xpath://*[contains(text(),'ROOT')]
    #Sleep  2s
    Press Keys      None       ENTER
    Sleep  2s

    #select user role
    click element       xpath://*[@class="form-group"][5]/*[@class="css-10nd86i"]
    #click element       xpath://*[contains(text(),'ADMIN (ROOT)')]
    #Sleep  2s
    Press Keys      None       ENTER
    Sleep  2s

    Wait Until Element Is Visible       xpath://*[@class="create-button btn btn-primary"]
    click element       xpath://*[@class="create-button btn btn-primary"]
    #close browser
    Sleep  10s


OpenMail
    [Arguments]     ${mailId}       ${mailPass}
    open mailbox        server=imap.googlemail.com       user=${mailId}     password=${mailPass}
    ${getLatestMail}        wait for email      fromEmail=${pccNotificationMailId}
    ${getLink}          get links from email       ${getLatestMail}
    log     get link is ${getLink}
    Set Global Variable     ${passwordLink}     ${getLink}[2]
    close mailbox

SetPassword
    [Arguments]     ${passwordLink}     ${newUserPass}
    #log     get passlink is ${passwordLink}
    go to       ${passwordLink}
    input text    xpath://input[@name="password"]       ${newUserPass}
    input text    xpath://input[@name="confirmPassword"]        ${newUserPass}
    click element       xpath://*[@class="btn-block btn btn-primary"]
    #close browser
    #Sleep  5s

LoginWithNewUser
    [Arguments]     ${mailId}     ${newUserPass}
    Wait Until Page Contains     Login

    input text    xpath://*[@class="login-form"]//input[@class="form-control "]      ${mailId}
    input text    xpath://*[@class="login-form"]//input[@class="form-control"]      ${newUserPass}
    click element     xpath://*[@class="btn-block btn btn-primary"]
    #Sleep  4s
    #close browser

LogOutCurrentUser
    #Wait Until Element Is Visible       xpath://*[@class="profile-icon"]
    Sleep  15s
    click element     xpath://*[@class="profile-icon"]
    #Sleep  2s
    Wait Until Page Contains     Log out
    #Wait Until Element Is Visible    xpath://*[@class="user-settings-menu__item"][2]
    click element       xpath://*[@class="user-settings-menu__item"][2]
    #Sleep  2s

LoginToAdmin
    [Arguments]     ${adminUserName}     ${adminPass}
    Wait Until Page Contains     Login
    input text    xpath://*[@class="login-form"]//input[@class="form-control "]      ${adminUserName}
    input text    xpath://*[@class="login-form"]//input[@class="form-control"]     ${adminPass}
    click element     xpath://*[@class="btn-block btn btn-primary"]
    #Sleep  2s

DeleteAllUser
    Wait Until Element Is Visible    xpath://a[starts-with(@href, '/gui/users')]
    click element       xpath://a[starts-with(@href, '/gui/users')]
    Wait Until Page Contains        ADMIN (ROOT)


    click element       xpath://*[@class="rt-column-header"]/*[@class="crud-data-table__select-column"]
    click element       xpath://*[@class="crud-data-table__buttons"]/*[@class="pcc-icon pcc-icon--active undefined"]
    Wait Until Element Is Visible       xpath://*[@class="btn btn-primary"]
    click element       xpath://*[@class="btn btn-primary"]

DeleteAllTenants
    Wait Until Element Is Visible    xpath://a[starts-with(@href, '/gui/tenants')]
    click element       xpath://a[starts-with(@href, '/gui/tenants')]
    Wait Until Page Contains        the root tenant

    click element       xpath://*[@class="rt-column-header"]/*[@class="crud-data-table__select-column"]
    click element       xpath://*[@class="crud-data-table__buttons"]/*[@class="pcc-icon pcc-icon--active undefined"]
    Wait Until Element Is Visible       xpath://*[@class="btn btn-primary"]
    click element       xpath://*[@class="btn btn-primary"]

privacy error page
    click element       id:advancedButton
    click element       id:exceptionDialogButton

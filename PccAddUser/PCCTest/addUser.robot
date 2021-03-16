*** Settings ***
Library        SeleniumLibrary
Library         ImapLibrary2
Suite Setup     open firefox
Suite Teardown      close browser


*** Variables ***
${url}      https://172.17.2.242:9999/gui/login
${browser}      firefox
${mailId}       anurag.jain@calsoftinc.com
${mailPass}     @19N*rEq
${pccNotificationMailId}        pcc_notifications@platinasystems.com
${newUserPass}      calsoft
${adminPass}      admin
${adminUserName}      admin
${passwordLink}

*** Test Cases ***

LoginTest
    #open browser        ${url}      ${browser}
    #maximize browser window

    #automate privacy error page
    ${titleOfPage}=      get window titles
    #Log     title value is ${titleOfPage}
    run keyword if      ${titleOfPage} == ['Warning: Potential Security Risk Ahead']     privacy error page

    #login to gui
    input text    xpath://*[@class="login-form"]//input[@class="form-control "]      ${adminUserName}
    input text    xpath://*[@class="login-form"]//input[@class="form-control"]     ${adminPass}
    click element     xpath://*[@class="btn-block btn btn-primary"]
    Sleep  4s

AddUser
    Wait Until Element Is Visible    xpath://a[starts-with(@href, '/gui/users')]
    click element       xpath://a[starts-with(@href, '/gui/users')]

    Wait Until Element Is Visible    xpath://*[@class="pcc-icon pcc-add-icon undefined pcc-icon--active undefined"]
    click element       xpath://*[@class="pcc-icon pcc-add-icon undefined pcc-icon--active undefined"]

    #add user details
    #Sleep  2s
    input text    xpath://*[@class="modal-body"]//input[@name="firstname"]      Anurag
    input text    xpath://*[@class="modal-body"]//input[@name="lastname"]      Jain
    input text    xpath://*[@class="modal-body"]//input[@name="username"]      ${mailId}

    #select tenant
    click element       xpath://*[@class="form-group"][4]/*[@class="css-10nd86i"]
    Sleep  2s
    Press Keys      None       ENTER
    Sleep  2s

    #select user role
    click element       xpath://*[@class="form-group"][5]/*[@class="css-10nd86i"]
    Sleep  2s
    Press Keys      None       ENTER
    Sleep  2s

    Wait Until Element Is Visible       xpath://*[@class="create-button btn btn-primary"]
    click element       xpath://*[@class="create-button btn btn-primary"]
    #close browser
    Sleep  10s

OpenMail
    open mailbox        server=imap-mail.outlook.com       user=${mailId}     password=${mailPass}
    ${getLatestMail}        wait for email      fromEmail=${pccNotificationMailId}
    ${getLink}          get links from email       ${getLatestMail}
    log     get link is ${getLink}
    Set Global Variable     ${passwordLink}     ${getLink}[2]
    close mailbox

SetPassword
    #log     get passlink is ${passwordLink}
    #open browser        ${passwordLink}      ${browser}
    go to       ${passwordLink}
    #maximize browser window
    #Sleep  4s

    input text    xpath://input[@name="password"]       ${newUserPass}
    input text    xpath://input[@name="confirmPassword"]        ${newUserPass}
    click element       xpath://*[@class="btn-block btn btn-primary"]
    #close browser
    #Sleep  5s

LoginWithNewUser
    #login again
    #Wait Until Element Is Visible       xpath://*[@class="btn-block btn btn-primary"]
    Wait Until Page Contains     Login

    input text    xpath://*[@class="login-form"]//input[@class="form-control "]      ${mailId}
    input text    xpath://*[@class="login-form"]//input[@class="form-control"]      ${newUserPass}
    click element     xpath://*[@class="btn-block btn btn-primary"]
    #Sleep  4s
    #close browser

LogOutCurrentUser
    #Wait Until Page Does Not Contain     Loading        10
    #Wait Until Element Is Visible       xpath://*[@class="profile-icon"]
    Sleep  15s
    click element     xpath://*[@class="profile-icon"]
    #Sleep  2s
    Wait Until Page Contains     Log out
    #Wait Until Element Is Visible    xpath://*[@class="user-settings-menu__item"][2]
    click element       xpath://*[@class="user-settings-menu__item"][2]
    #Sleep  2s
    #close browser

LoginToAdmin
    #open browser        ${url}      ${browser}
    #maximize browser window
    #login to gui
    Wait Until Page Contains     Login
    input text    xpath://*[@class="login-form"]//input[@class="form-control "]      ${adminUserName}
    input text    xpath://*[@class="login-form"]//input[@class="form-control"]     ${adminPass}
    click element     xpath://*[@class="btn-block btn btn-primary"]
    #Sleep  2s

DeleteUser
    Wait Until Element Is Visible    xpath://a[starts-with(@href, '/gui/users')]
    click element       xpath://a[starts-with(@href, '/gui/users')]
    Wait Until Page Contains        ${mailId}

    #Wait Until Element Is Visible    xpath://*[@class="pcc-icon pcc-icon--disabled undefined"]
    #Sleep  5s

    click element       xpath://*[@class="rt-column-header"]/*[@class="crud-data-table__select-column"]
    click element       xpath://*[@class="crud-data-table__buttons"]/*[@class="pcc-icon pcc-icon--active undefined"]
    Wait Until Element Is Visible       xpath://*[@class="btn btn-primary"]
    click element       xpath://*[@class="btn btn-primary"]

    #Sleep  3s
    #close browser

*** Keywords ***

privacy error page
    click element       id:advancedButton
    click element       id:exceptionDialogButton

open firefox
    open browser        ${url}      ${browser}
    maximize browser window

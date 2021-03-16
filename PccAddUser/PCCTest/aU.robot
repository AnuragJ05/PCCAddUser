*** Settings ***
Library        SeleniumLibrary
Library         ImapLibrary2

*** Variables ***
${url}      https://172.17.2.242:9999/gui/login
${browser}      firefox
${passwordLink}

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

AddUser
    Wait Until Element Is Visible    xpath:/html/body/div/div[2]/div[2]/div/div[21]/a
    click element       xpath:/html/body/div/div[2]/div[2]/div/div[21]/a

    Wait Until Element Is Visible    xpath:/html/body/div/div[2]/div[3]/div/div[2]/div/div/div[1]/div[2]/div[2]
    click element       xpath:/html/body/div/div[2]/div[3]/div/div[2]/div/div/div[1]/div[2]/div[2]

    #add user details
    Sleep  2s
    input text    xpath:/html/body/div[3]/div/div/div[2]/form/div[1]/input      Anurag
    input text    xpath:/html/body/div[3]/div/div/div[2]/form/div[2]/input      Jain
    input text    xpath:/html/body/div[3]/div/div/div[2]/form/div[3]/input      anurag.jain@calsoftinc.com

    #select tenant
    click element       xpath:/html/body/div[3]/div/div/div[2]/form/div[4]/div
    Sleep  2s
    Press Keys      None       ENTER

    #select user role
    click element       xpath:/html/body/div[3]/div/div/div[2]/form/div[5]/div
    Sleep  2s
    Press Keys      None       ENTER

    Wait Until Element Is Visible       xpath:/html/body/div[3]/div/div/div[2]/form/div[7]/button[1]
    click element       xpath:/html/body/div[3]/div/div/div[2]/form/div[7]/button[1]
    close browser

    Sleep  10s

OpenMail
    open mailbox        server=imap-mail.outlook.com       user=anurag.jain@calsoftinc.com     password=@19N*rEq
    ${getLatestMail}        wait for email      fromEmail=pcc_notifications@platinasystems.com
    ${getLink}          get links from email       ${getLatestMail}
    log     get link is ${getLink}
    Set Global Variable     ${passwordLink}     ${getLink}[2]
    close mailbox

SetPassword
    #log     get passlink is ${passwordLink}
    open browser        ${passwordLink}      ${browser}
    maximize browser window
    Sleep  4s
    input text    xpath:/html/body/div/div[2]/div/div[2]/div/form/div[1]/div[1]/input      admin
    input text    xpath:/html/body/div/div[2]/div/div[2]/div/form/div[2]/div/input      admin
    click element       xpath:/html/body/div/div[2]/div/div[2]/div/form/button
    Sleep  5s

    #login again
    input text    xpath:/html/body/div/div[2]/div/div[2]/div/form/div[1]/input      anurag.jain@calsoftinc.com
    input text    xpath:/html/body/div/div[2]/div/div[2]/div/form/div[2]/div[2]/input     admin
    click element     xpath:/html/body/div/div[2]/div/div[2]/div/form/button
    Sleep  4s
    #close browser
DeleteUser
      Wait Until Element Is Visible    xpath://a[starts-with(@href, '/gui/users')]
    click element       xpath://a[starts-with(@href, '/gui/users')]

    Wait Until Element Is Visible    xpath://*[@class="pcc-icon pcc-icon--disabled undefined"]
    Sleep  5s

    click element       xpath://*[@class="rt-column-header"]/*[@class="crud-data-table__select-column"]
    click element       xpath://*[@class="crud-data-table__buttons"]/*[@class="pcc-icon pcc-icon--active undefined"]
    Wait Until Element Is Visible       xpath://*[@class="btn btn-primary"]
    click element       xpath://*[@class="btn btn-primary"]

    Sleep  3s
    close browser



*** Keywords ***

privacy error page
    click element       id:advancedButton
    click element       id:exceptionDialogButton





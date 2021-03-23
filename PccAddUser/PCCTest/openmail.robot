*** Settings ***
Library        SeleniumLibrary
Library         ImapLibrary2

*** Variables ***
${adminUserMailId}      calsoftplatina@gmail.com
${adminUserMailPass}        plat1n@!
${adminUserFName}       platina
${adminUserLName}       systems
${pccNotificationMailId}        pcc_notifications@platinasystems.com


*** Test Cases ***

OpenMail
    #log to console     ${adminUserMailId}
    #log to console     ${adminUserMailPass}
    open mailbox        server=imap.googlemail.com       user=${adminUserMailId}     password=${adminUserMailPass}
    ${getLatestMail}        wait for email      fromEmail=${pccNotificationMailId}
    ${getLink}          get links from email       ${getLatestMail}
    log     get link is ${getLink}
    Set Global Variable     ${passwordLink}     ${getLink}[2]
    close mailbox

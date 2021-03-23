*** Settings ***
Library        SeleniumLibrary
Library         ImapLibrary2
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

open firefox with proxy
	${profile}=   Evaluate   sys.modules['selenium.webdriver'].FirefoxProfile()  sys
	Call Method   ${profile}   set_preference   network.proxy.socks   127.0.0.1
	Call Method   ${profile}   set_preference   network.proxy.socks_port  ${9000}
	Call Method   ${profile}   set_preference   network.proxy.socks_remote_dns  ${True}
	Call Method   ${profile}   set_preference   network.proxy.type   ${1}
	Create WebDriver   Firefox   firefox_profile=${profile}
	maximize browser window
	Go To    ${url}
*** Settings ***
Library					SeleniumLibrary
Test Setup				Open Login Page
Test Teardown				Close Browser

*** Variables ***
${PASS}					secret_sauce
${LOGIN_PAGE}				https://www.saucedemo.com/
${INVENTORY_PAGE}			https://www.saucedemo.com/inventory.html
${UNKNOWN_USER_ERROR}			Epic sadface: Username and password do not match any user in this service
${LOCKEDOUT_USER_ERROR}			Epic sadface: Sorry, this user has been locked out.

*** Test Cases ***
Log in with valid user
	Log in as			standard_user	${PASS}
	Wait Until Location is not	${LOGIN_PAGE}
	Location should be		${INVENTORY_PAGE}	

Log in with invalid user
	Log in as			invalid_user	${PASS}
	Error should be			${UNKNOWN_USER_ERROR}

Log in with locked out user
	Log in as			locked_out_user	${PASS}
	Error should be			${LOCKEDOUT_USER_ERROR}

*** Keywords ***
Open Login Page
	Open Browser			${LOGIN_PAGE}	Firefox	service_log_path=${{"../driver_logs/geckodriver"}}

Log in as
	[Arguments]			${username}	${password}	
	Input Text			id:user-name	${username}
	Input Password			name:password	${password}	#Input Password hides the password in the INFO level
	Click Button 			id:login-button

Error should be
	[Arguments]			${error_expected}
	${error_text}=			Get Text	class:error-message-container
	Should Be Equal			${error_text}	${error_expected}

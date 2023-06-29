*** Settings ***
Library					SeleniumLibrary
Variables				../variables/map.py
Variables				../variables/errors.py
Test Setup				Open Login Page
Test Teardown				Close Browser

*** Variables ***
${VALID_USER}				standard_user
${LOCKED_USER}				locked_out_user	
${PASSWORD}				secret_sauce

*** Test Cases ***

Empty Username
	Log in as			${EMPTY}			${PASSWORD}
	Error should be			${EMPTY_USERNAME_ERROR}

Empty Password
	Log in as			${VALID_USER}			${EMPTY}
	Error should be			${EMPTY_PASSWORD_ERROR}
	
Invalid Username
	Log in as			'hacker' OR 1=1			${PASSWORD}
	Error should be			${UNKNOWN_USER_ERROR}

Invalid Password
	Log in as			${VALID_USER}			'hacker' OR 1=1
	Error should be			${UNKNOWN_USER_ERROR}

Locked out user
	Log in as			${LOCKED_USER}			${PASSWORD}
	Error should be			${LOCKEDOUT_USER_ERROR}

Access without login
	Go to				${URL_INVENTORY}
	Error should be			${NOT_LOGGED_IN_ERROR}

Valid user
	Log in as			${VALID_USER}			${PASSWORD}
	Wait Until Location is not	${URL_LOGIN}
	Location should be		${URL_INVENTORY}		

*** Keywords ***
Open Login Page
	Open Browser			${URL_LOGIN}			Firefox				service_log_path=${{"driver_logs/geckodriver"}}

Log in as
	[Arguments]			${username}			${password}	
	Input Text			${INPUT_USERNAME}		${username}
	Input Password			${INPUT_PASSWORD}		${password}
	Click Button 			${BUTTON_LOGIN}

Error should be
	[Arguments]			${error_expected}
	${error_text}=			Get Text			${ELEMENT_ERROR_CONTAINER}
	Should Match			${error_text}			${error_expected}

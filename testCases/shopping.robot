*** Settings ***
Library					SeleniumLibrary
Variables				../variables/map.py	#Separate file with the locators of page elements.
Test setup				Open login page
Test teardown				Close browser

*** Variables ***
# -- User Variables --
${USER}			    		standard_user
${PASS}			    		secret_sauce
${FIRST_NAME}		    		John
${LAST_NAME}		    		Doe
${ZIP_CODE}		    		123456

*** Test Cases ***
# In this test case, I took the high-level approach, using a BDD-style keyword definition
Clear cart after checkout completion
	Given a valid user is logged in
	When they buy a product
	And they click on the cart button
	Then the cart is empty

Disable checkout button if cart is empty
	Given a valid user is logged in
	When they add a product to cart
	And they click on the cart button
	And they remove all itens from the cart
	Then the checkout button is disabled

*** Keywords ***
# -- Setup --
Open Login Page
	Open browser			${URL_LOGIN}	Firefox	service_log_path=${{"../driver_logs/geckodriver"}}

# -- Users --
a valid user is logged in
	Input text			${INPUT_USERNAME}	${USER}
	Input password			${INPUT_PASSWORD}	${PASS}
	Click element			${BUTTON_LOGIN}
	Wait Until Location is not	${URL_LOGIN}

# -- Actions --
they add a product to cart
	Click element			${BUTTON_ADD_TO_CART}

they click on the cart button
	Click element			${ELEMENT_CART}

they click on the checkout button
	Click element			${BUTTON_CHECKOUT}

they fill the delivery information form
	Input text			${INPUT_FIRST_NAME}	${FIRST_NAME}
	Input text			${INPUT_LAST_NAME}	${LAST_NAME}
	Input text			${INPUT_ZIP_CODE}	${ZIP_CODE}

they click on the continue button
	Click button			${BUTTON_CONTINUE}

they click on the finish button
	Click button			${BUTTON_FINISH}

they remove all itens from the cart
	@{remove_buttons}=		Get WebElements		${BUTTON_REMOVE}
	FOR	${button}	IN	@{remove_buttons}
		Click element		${button}
	END

they buy a product
	they add a product to cart
	they click on the cart button
	they click on the checkout button
	they fill the delivery information form
	they click on the continue button
	they click on the finish button
	the page is the "checkout complete" page
	
# -- Validation --

the cart is empty
	Page should not contain element	${ELEMENT_CART_ITEM}

the checkout button is disabled
	Element should be disabled	${BUTTON_CHECKOUT}

the page is the "checkout complete" page
	Location should be		${URL_CHECKOUT_COMPLETE}

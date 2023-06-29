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
	Given valid user is logged in
	When buy a product
	And click on the cart button
	Then cart is empty

Disable checkout button if cart is empty
	Given valid user is logged in
	When add a product to cart
	And click on the cart button
	And remove all itens from the cart
	Then checkout button is disabled

*** Keywords ***
# -- Setup --
Open Login Page
	Open browser			${URL_LOGIN}		Firefox		service_log_path=${{"driver_logs/geckodriver"}}

# -- Users --
Valid user is logged in
	Input text			${INPUT_USERNAME}	${USER}
	Input password			${INPUT_PASSWORD}	${PASS}
	Click element			${BUTTON_LOGIN}
	Wait Until Location is not	${URL_LOGIN}

# -- Actions --
Add a product to cart
	Click element			${BUTTON_ADD_TO_CART}

Click on the cart button
	Click element			${ELEMENT_CART}

Click on the checkout button
	Click element			${BUTTON_CHECKOUT}

Fill the delivery information form
	Input text			${INPUT_FIRST_NAME}	${FIRST_NAME}
	Input text			${INPUT_LAST_NAME}	${LAST_NAME}
	Input text			${INPUT_ZIP_CODE}	${ZIP_CODE}

Click on the continue button
   	Click button			${BUTTON_CONTINUE}

Click on the finish button
   	Click button			${BUTTON_FINISH}

Remove all itens from the cart
  	@{remove_buttons}=		Get WebElements		${BUTTON_REMOVE}
  	FOR	${button}	IN	@{remove_buttons}
  		Click element		${button}
  	END

Buy a product
	add a product to cart
	click on the cart button
	click on the checkout button
	fill the delivery information form
	click on the continue button
	click on the finish button
	page is the "checkout complete" page
	
# -- Validation --

Cart is empty
	Page should not contain element	${ELEMENT_CART_ITEM}

Checkout button is disabled
	Element should be disabled	${BUTTON_CHECKOUT}

Page is the "checkout complete" page
	Location should be		${URL_CHECKOUT_COMPLETE}

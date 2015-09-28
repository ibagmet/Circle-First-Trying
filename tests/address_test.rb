require 'test_helper'
require 'faker'

class AddressTest < NibleyTest
	include BaseCheckoutHelper
	include StandardCheckoutHelper


		def test_my_account
		goto "/login"
    browser.link(text: "Create a new account").click
    email_new = ::Faker::Internet.safe_email
    browser.text_field(name: "spree_user[email]").set email_new
    browser.text_field(name: "spree_user[first_name]").set 'test'
    browser.text_field(name: "spree_user[last_name]").set 'user'
    browser.text_field(name: "spree_user[password]").set 'test123'
    browser.text_field(name: "spree_user[password_confirmation]").set 'test123'
    browser.form(id: "new_spree_user").when_present.submit
    
		assert browser.text.include?('Welcome! You have signed up successfully.'), "Account was not successfully created."
		browser.a(text: "My Account").click
		assert_equal("#{base_url}/account", browser.url, "incorrect location")
    assert browser.text.include?("My Account")
  	assert(
		browser.h3(text: 'Saved Addresses').exists?,
			'Expected to find <h3> tag with text "Saved Addresses" but did not.'
		)
    address_in_ckecking
    sleep(1) #animation
    browser.a(text: "Add new address").click
    assert_equal("#{base_url}/addresses/new", browser.url, "incorrect location")
    assert browser.text.include?("New Address")
    browser.text_field(name: "address[firstname]").set 'test'
    browser.text_field(name: "address[lastname]").set 'user'
    browser.text_field(name: "address[address1]").set '5000 M St'
    browser.text_field(name: "address[city]").set 'Munich'
    browser.select_list(name: "address[state_id]").select 'Hawaii'
    browser.text_field(name: "address[zipcode]").set '55667'
    browser.select_list(name: "address[country_id]").select 'United States of America'
    browser.text_field(name: "address[phone]").set '555-5555'
	  confirm_address

    creating_fake_address_number_2
		confirm_address
    address_in_ckecking 
    assert(
		browser.h3(text: 'Saved Addresses').exists?,
			'Expected to find <h3> tag with text "Saved Addresses" but did not.'
		)
    address_tr = browser.driver.find_elements(tag_name: 'tr', class: 'address').detect{|tr|
    tr.find_elements(tag_name: 'address').detect{|address| address.text =~ /Munich/}
    }
    address_tr.find_elements(tag_name: 'a').detect{|a| a.text == 'Remove'}.click
    browser.driver.switch_to.alert.accept

    browser.a(text: "Addresses").click
    assert_equal("#{base_url}/account", browser.url, "incorrect location")
	  assert(
		browser.h3(text: 'Saved Addresses').exists?,
		'Expected to find <h3> tag with text "Saved Addresses" but did not.'
		)
	  browser.driver.page_source.include? 'Munich'
            
    goto "/logout"
            
	  end

    private

    def address_in_ckecking 
    browser.a(text: "Addresses").click
    assert_equal("#{base_url}/account", browser.url, "incorrect location")
    assert browser.text.include?("My Account")
    end

    def creating_fake_address_number_2
    address_in_ckecking
    sleep(1) #animation
    browser.a(text: "Add new address").click
    assert_equal("#{base_url}/addresses/new", browser.url, "incorrect location")
    assert browser.text.include?("New Address")
    browser.text_field(name: "address[firstname]").set Faker::Name.name
    browser.text_field(name: "address[lastname]").set  Faker::Name.last_name
    browser.text_field(name: "address[address1]").set Faker::Address.street_address
    browser.text_field(name: "address[city]").set Faker::Address.city
    browser.select_list(name: "address[state_id]").select 'Hawaii'
    browser.text_field(name: "address[zipcode]").set Faker::Address.zip
    browser.select_list(name: "address[country_id]").select 'United States of America'
    browser.text_field(name: "address[phone]").set Faker::PhoneNumber.cell_phone
    end

    def confirm_address
    browser.input(name: "commit").click
    assert_equal("#{base_url}/account", browser.url, "incorrect location")
    assert(browser.div(class: 'flash notice').present?) 
    end

  end
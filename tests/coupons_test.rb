require 'test_helper'

class CouponsTest < NibleyTest

    def test_coupons_cases
        clear_cookies
        goto '/login'
        browser.text_field(name: "spree_user[email]").set 'ibagmet@deseretbook.com'
        browser.text_field(name: "spree_user[password]").set 'test123'
        browser.input(name: "commit").click
        assert_equal(browser.div(class: 'flash success').text, "Logged in successfully")
        goto '/cart'
        browser.input(class: "btn btn-sm btn-link-plain").click
        browser.text_field(name: "keywords").set 'The Book of Mormon for Latter-day Saint Families'
        browser.input(class: "btn btn-primary img-responsive js-search-button").click
        assert(browser.h1(text: "Search results for 'The Book of Mormon for Latter-day Saint Families'").exists?)
        browser.a(text: "Hardcover").click
        browser.button(class: "btn btn-lg btn-primary btn-block btn-add-to-cart").click
        assert_equal("#{base_url}/item_added", browser.url, "incorrect location")
        browser.a(class: "btn btn-primary text-uppercase continue").click
        assert_equal("#{base_url}/cart", browser.url, "incorrect location")
        #browser.a(text: "Close").click
        browser.a(class: "btn btn-primary btn-lg pull-right btn-checkout").when_present.click
        assert_equal("#{base_url}/checkout/address", browser.url, "incorrect location")
        browser.button(class: "btn btn-primary pull-right js-form-validate btn-continue").when_present.click
        assert_equal("#{base_url}/checkout/delivery", browser.url, "incorrect location")
        browser.button(class: "btn btn-primary pull-right btn-continue").when_present.click
        assert_equal("#{base_url}/checkout/payment", browser.url, "incorrect location")
        
        browser.a(text: "Enter coupon code").when_present.click
        sleep(1) #animation
        browser.text_field(name: "order[coupon_code]").set 'test123_50'
        browser.button(text: "Apply Coupon Code").click
        browser.div(text: "The coupon code was successfully applied to your order.").exists?
        
        return_option #nesessary for firefox - after applying valid cupons - makes disable buttons
        
        browser.a(text: "Enter coupon code").when_present.click
        sleep(1) #animation
        browser.text_field(name: "order[coupon_code]").set 'test123_one_more'
        browser.button(text: "Apply Coupon Code").click
        browser.div(text: "The coupon code was successfully applied to your order.").exists?
        
        return_option #nesessary for firefox - after applying valid cupons - makes disable buttons

        browser.a(text: "Enter coupon code").when_present.click
        sleep(1) #animation
        browser.text_field(name: "order[coupon_code]").set 'smth_strange'
        browser.button(text: "Apply Coupon Code").when_present.click
        browser.div(text: "The coupon code you entered doesn't exist. Please try again.").exists?

        browser.text_field(name: "order[coupon_code]").set 'test123_expired'
        browser.button(text: "Apply Coupon Code").when_present.click
        browser.div(text: "The coupon code is expired").exists?
        
        browser.text_field(name: "order[coupon_code]").set 'test_only_for_cristmas'
        browser.button(text: "Apply Coupon Code").when_present.click
        browser.div(text: "This coupon code could not be applied to the cart at this time.").exists?
        sleep(1)
        browser.text_field(name: "order[coupon_code]").set 'test123_50'
        browser.button(text: "Apply Coupon Code").when_present.click
        browser.div(text: "The coupon code has already been applied to this order").exists?

        browser.text_field(name: "order[coupon_code]").set '' #nesessary to pass  through
        browser.button(class: "btn btn-primary pull-right btn-continue js-submit-btn").when_present.click
        assert_equal("#{base_url}/checkout/confirm", browser.url, "incorrect location")
        browser.button(class: "btn btn-primary btn-lg pull-right btn-continue").when_present.click
        assert_equal(browser.div(class: 'flash notice').text, "Thank You. We have successfully received your order.")

        logout
	end
    
    private
    
    def return_option
        browser.a(text: "Delivery").click
        assert_equal("#{base_url}/checkout/delivery", browser.url, "incorrect location")
        browser.button(class: "btn btn-primary pull-right btn-continue").click
    end

end
 
require 'test_helper'
require 'faker'

class ItemAdded < NibleyTest

  def test_item_in_cart

    goto  '/signup' 
      email_new = ::Faker::Internet.safe_email
      browser.text_field(name: "spree_user[email]").set email_new
          browser.text_field(name: "spree_user[first_name]").set 'test_name'
          browser.text_field(name: "spree_user[last_name]").set 'test_last_name'
      browser.text_field(name: "spree_user[password]").set 'test123'
          browser.text_field(name: "spree_user[password_confirmation]").set 'test123'
          browser.input(name: "commit").click
            assert(browser.div(class: 'flash notice').present?)
            goto '/cart'
            browser.a(text: "Continue shopping").exists?
            browser.a(text: "Continue shopping").click
            assert_equal("#{base_url}/products?sort=popular", browser.url, "incorrect location")
            browser.a(text: "19 inch").click
            assert_equal("#{base_url}/p/marble-christus-statue-deseret-book-company-41038?variant_id=62304-19-inch", browser.url, "incorrect location")
            browser.button(text: "Add To Cart").click
            assert_equal("#{base_url}/item_added", browser.url, "incorrect location")
            browser.a(text: "Proceed to Checkout").exists?
            browser.a(text: "Proceed to Checkout").click
            assert_equal("#{base_url}/cart", browser.url, "incorrect location")
            browser.close

            browser = open_browser
          browser.goto 'https://stage.deseretbook.com/login'
      browser.text_field(name: "spree_user[email]").set email_new
        browser.text_field(name: "spree_user[password]").set 'test123'
        browser.input(name: "commit").click
        browser.goto 'https://stage.deseretbook.com/cart' 
        browser.a(text: "Marble Christus Statue").exists?
      browser.close

      browser = open_browser
      browser.goto 'https://stage.deseretbook.com/cart'
      browser.a(text: "Marble Christus Statue").exists?
      browser.close

       
        end

    end

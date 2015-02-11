require 'minitest/spec'
require 'minitest/autorun'
require 'watir-webdriver'

require 'helpers/base_checkout_helper'
require 'helpers/standard_checkout_helper'
require 'helpers/guest_checkout_helper'
require 'helpers/gift_card_helper'

include Selenium
 
class NibleyTest < Minitest::Test
  attr_reader :browser

  def setup 
    #@browser ||= Watir::Browser.new :firefox
    
    caps = WebDriver::Remote::Capabilities.new
    caps[:name] = "Watir WebDriver"
    
    # IE 10 on windows 8
    # caps['browser'] = 'IE'
    # caps['browser_version'] = '10.0'
    # caps['os'] = 'Windows'
    # caps['os_version'] = '8'
    # caps['resolution'] = '1024x768'
    # caps["browserstack.debug"] = "true"
    # caps['browserstack.local'] = "true"
    
    # iphone 5
    caps[:browserName] = 'iPhone'
    caps[:platform] = 'MAC'
    caps[:device] = 'iPhone 5'
    caps['browserstack.debug'] = "true"
    caps['browserstack.local'] = "true"

    @browser ||= Watir::Browser.new(:remote, :url => "http://MatthewRedd:SPcNqvdg4Kd4qvjp294S@hub.browserstack.com/wd/hub", :desired_capabilities => caps)
    
  end
   
  def teardown 
    @browser.close
  end

  def base_url
    "https://nibley.deseretbook.com"
  end

  def goto(route)
    @browser.goto "#{base_url}#{route}"
  end

  def logout
    goto "/logout"
  end

  def login
    logout

    goto "/login"
    browser.text_field(name: "spree_user[email]").set 'tests@deseretbook.com'
    browser.text_field(name: "spree_user[password]").set 'test123'
    browser.input(name: "commit").when_present.click
  end

end

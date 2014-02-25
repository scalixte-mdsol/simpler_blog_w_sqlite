# Provide methods to help manage cookies in steps.

module CookiesHelper
  # Add a cookie to the browser's cookie store
  def add_cookie!(name, value, options = {})
    raise ArgumentError.new("value must be a string") unless value.is_a?(String)

    # sign the value using Rails
    if options[:signed]
      jar = ActionDispatch::Cookies::CookieJar.new(Checkmate::Application.config.secret_token)
      jar.signed["temp"] = value
      value = jar.instance_variable_get(:@cookies)["temp"]
    end

    browser.add_cookie(:name => name, :value => CGI.escape(value))
  end

  # Delete a cookie from the browser's cookie store
  def delete_cookie(name)
    browser.delete_cookie(name)
  end

  # Fetch a cookie value from the browser's cookie store
  def get_cookie(name)
    browser.cookie_named(name)
  end

  # Array of all cookies
  def get_all_cookies
    browser.all_cookies
  end

  private

    # Get the current browser object.  We manage cookies through it.
    def browser
      @browser ||= if Capybara.current_session.driver.is_a?(Capybara::Selenium::Driver)
        Capybara.current_session.driver.browser.manage
      else
        raise "Driver cannot be used to manage cookies. Use selenium/webdriver.  Rack::Test should be supported soon."
      end
    end
end

World(CookiesHelper)

require 'capybara'
require 'selenium/webdriver'
require 'capybara/poltergeist'

# remove superflous font logging messages on osx mavericks
# TODO remove once a fix is in place on phantomjs
# see https://github.com/ariya/phantomjs/issues/11418
module Capybara::Poltergeist
  class Client
    private
    def redirect_stdout
      prev = STDOUT.dup
      prev.autoclose = false
      $stdout = @write_io
      STDOUT.reopen(@write_io)

      prev = STDERR.dup
      prev.autoclose = false
      $stderr = @write_io
      STDERR.reopen(@write_io)
      yield
    ensure
      STDOUT.reopen(prev)
      $stdout = STDOUT
      STDERR.reopen(prev)
      $stderr = STDERR
    end
  end
end


class WarningSuppressor
  class << self
    def write(message)
      if message =~ /QFont::setPixelSize: Pixel size <= 0/ || message =~/CoreText performance note:/ then 0 else puts(message);1;end
    end
  end
end

# Register all supported browser.
# Note:  some browsers may not (yet) be supported in a particular OS. Hopefully,
# this list of browsers will expand soon.
supported_browsers = [:firefox, :chrome, :ie, :safari]
supported_browsers.each do |browser|
  Capybara.register_driver browser do |app|
    download_path = DownloadHelpers::PATH.to_s
    case browser
      when :firefox
        profile = "Selenium::WebDriver::#{browser.capitalize}::Profile".constantize.new
        profile['browser.download.dir'] = download_path
        profile['browser.download.folderList'] = 2
        Capybara::Selenium::Driver.new(app, browser: browser, profile: profile)
      when :chrome
        prefs = {
            download: {
                prompt_for_download: false,
                default_directory: download_path
            }
        }
        Capybara::Selenium::Driver.new(app, browser: browser, service_log_path: 'chromedriver.log', prefs: prefs)
      when :ie
        Capybara.server_host = '192.168.56.1' # ENV['SERVER_HOST']
        capabilities = Selenium::WebDriver::Remote::Capabilities.internet_explorer(javascript_enabled: true, native_events: true)
        Capybara::Selenium::Driver.new(
            #app, browser: :remote, url: "http://#{ENV['SERVER_HOST']}:4444/wd/hub", desired_capabilities: capabilities
            app, browser: :remote, url: "http://192.168.56.1:4444/wd/hub", desired_capabilities: capabilities
        )
      when :safari
        #Capybara::Selenium::Driver.new(app, :browser =&amp;gt; :safari)
        Capybara::Selenium::Driver.new(app, browser: browser)
      else
        raise "Non-supported browser provided: #{browser.to_s}"
    end
  end
end

begin

  Capybara.default_selector = :css
  Capybara.default_wait_time = 5

  Capybara.run_server = true

  Capybara.register_driver :poltergeist do |app|
    Capybara::Poltergeist::Driver.new(app, phantomjs_logger: WarningSuppressor)
  end

  Capybara.default_driver = :selenium #:poltergeist

  rescue NameError
    raise "You need to add capybara to your Gemfile (in the :test group) if you wish to use it."
end

Before do
  # Let developer choose the brower on which to run headed (@javascript) scenarios.
  chosen_browser = ENV['CAPYBARA_BROWSER'].try(:to_sym)
  chosen_browser = :chrome unless supported_browsers.include?(chosen_browser)
  Capybara.javascript_driver = chosen_browser
  Capybara.current_driver = Capybara.javascript_driver
end

# Run headless JS with poltergeist
Before '@headless-javascript' do
  Capybara.current_driver = :poltergeist
end

# Run headless JS with poltergeist
Before '@headless-no-javascript' do
  Capybara.current_driver  = :rack_test # This driver is fast and headless but doesn't support JS.
end

# If we are told to take a screenshot for this scenario then set the current_driver accordingly.
if ENV['SCREENSHOT_FOR']
  Before ENV['SCREENSHOT_FOR'] do
    Capybara.current_driver = Capybara.javascript_driver
  end
end

# Switch to default driver at the end of every scenario.  Let the next scenario choose whether or not it wants
# to stray from the default.
# This constant switching shouldn't have any performance implications as switching is supposed to be cheap.
After do
  Capybara.use_default_driver
end
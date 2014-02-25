# Return boolean indicating whether or not current capybara driver can execute js or not.
def capybara_driver_can_execute_script?
  begin
    Capybara.current_session.driver.execute_script('')
    true
  rescue Capybara::NotSupportedByDriverError
    false
  end
end

# Generates a full URI from a given path that references the site domain.
# Needed becuase the Action Controller _url helpers reference the www.example.com domain.
def blog_uri(path, query)
  uri = URI.parse(current_url)
  uri.path = path
  uri.query = query
  uri.to_s
end


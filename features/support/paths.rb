module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in web_steps.rb
  #
  def path_to(page_name, user_name=nil)
    begin
      case page_name
        when /^(?:|the\s?)home\s?page$/
          root_path
        when /^(?:|the\s?)product(?:|s)\s?(?:|_)page$/
          products_path
        when /^(?:|the\s?)study|studies\s?(?:|_)page$/
          studies_path
        when /^the (.*) page$/
          path_components = $1.split(/\s+/)
          self.send(path_components.push('path').join('_').to_sym)
      else
        raise ArgumentError
      end
    rescue NoMethodError, ArgumentError
      raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
        "Now, go and add a mapping in #{__FILE__}"
    end
  end
end

World(NavigationHelpers)

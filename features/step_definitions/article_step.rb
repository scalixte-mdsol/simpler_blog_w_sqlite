Given /^I have articles authored by (.+)$/ do |authors|
  authors.split(', ').each do |author|
    Article.create!(:author => author.sub('and ',''))
  end
end

Given /^I have articles titled (.+)$/ do |titles|
  titles.split(', ').each do |title|
    Article.create!(:title => title)
  end
end

When /^I insert these articles:$/ do |table|
  table.hashes.map do |articles|
    Article.create!(:author => articles["author"], :title => articles["title"], :content => articles["content"])
  end
end

When /^(?:I go to|I am) (.+)$/ do |page_name|
  case page_name
    when /the homepage/
      visit root_path
    when /the main page/
      visit root_path
    when /the list of articles/
      visit articles_path
    when /new article/
      visit new_article_path
    when /article/
      visit article_path
    else
      raise "Can't find mapping from \"#{page_name}\" to a path."
    #end
  end
end

Then /^I should see "([^\"]*)"$/ do |text|
  #print "\n******\n" + page.body.to_s + "\n*****\n"
  #page.body.should have_content(text)
  page.should have_content(text)
  #expect(page).to have_content(text)
end

Given /^I have no articles(?:|.*)$/ do
  Article.delete_all
end

Then /^I should (?:have|see) ([0-9]+) articles?$/ do |count|
  Article.count.should == count.to_i
end

When /^I (?:follow|click on) "?(.*?)"?$/ do |link|
  click_link link
end

When /^I (?:fill in|enter a value for) "(.*?)" (?:with|as) "(.*?)"$/ do |field, value|
  fill_in(field, :with => value)
end

When /^I press "(.*?)"$/ do |link|
  click_button link
end

Then /^I should see under "(.*?)": (?:|")(.+)(?:|")$/ do |field, values|
  values.split(', ').each do |value|
    text = value.sub('and ','')
    #expect(page).to have_content(text)
    page.should have_content(text)
  end
end

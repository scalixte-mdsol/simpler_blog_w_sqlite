require 'database_cleaner'
require 'database_cleaner/cucumber'


Before do
  #puts "\n ********* call was made **********\n"
  #DatabaseCleaner.clean
  DatabaseCleaner.start
end

Before do |scenario|
  #puts "\n ********* call before scenario was made **********\n"
  #DatabaseCleaner.clean
  #DatabaseCleaner.start
end

# You may also want to configure DatabaseCleaner to use different strategies for certain features and scenarios.
# See the DatabaseCleaner documentation for details. Example:
#
Before('@no-txn,@selenium,@culerity,@celerity,@javascript') do
  #puts "\n ********* call was culerity made **********\n"
  # { :except => [:widgets] } may not do what you expect here
  # as Cucumber::Rails::Database.javascript_strategy overrides
  # this setting.
  #DatabaseCleaner.clean
  #DatabaseCleaner.strategy = :truncation
end

Before('~@no-txn', '~@selenium', '~@culerity', '~@celerity', '~@javascript') do
  #puts "\n ********* call was selenium made **********\n"
  #DatabaseCleaner.clean
  #DatabaseCleaner.strategy = :transaction
end


After do |scenario|
  #puts "\n ********* call after scenario made **********\n"
  #DatabaseCleaner.clean
  DatabaseCleaner.clean_with(:truncation)
end


After do
  #puts "\n ********* call after made **********\n"
  DatabaseCleaner.clean
  #DatabaseCleaner.clean_with(:truncation)
end
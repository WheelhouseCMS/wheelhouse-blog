ENV["RAILS_ENV"] ||= "test"
require File.expand_path("../../sandbox/config/environment",  __FILE__)

require 'rspec/rails'
require 'wheelhouse/rspec/matchers'

require 'wheelhouse-blog'

RSpec.configure do |config|
  config.mock_with :rspec
  
  config.before(:each) do
    MongoModel.database.collections.each do |collection|
      collection.drop unless collection.name =~ /^system\./
    end
  end
end

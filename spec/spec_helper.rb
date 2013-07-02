require 'simplecov'
SimpleCov.start do
  add_filter '/spec'
end

require 'rspec'
require 'daodalus'

require 'support/mongo_cleaner'

RSpec.configure do |config|
  config.order = :rand
  config.color_enabled = true
  config.before(:each) { MongoCleaner.clean }
end

conn = Moped::Session.new(['localhost:27017'])
Daodalus::Connection.register(conn)

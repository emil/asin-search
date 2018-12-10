ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require 'mocha/minitest'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  # fixtures :all
  self.use_transactional_tests = true
  self.use_instantiated_fixtures  = false
  # Add more helper methods to be used by all tests here...

  def read_fixture_file(file_name)
    fixture_file_name = File.join(Rails.root, 'test', 'fixtures', 'files', file_name)
    IO.readlines(fixture_file_name).join
  end
end

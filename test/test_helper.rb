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

  protected
  
  def read_fixture_file(file_name)
    fixture_file_name = File.join(Rails.root, 'test', 'fixtures', 'files', file_name)
    IO.readlines(fixture_file_name).join
  end

  # stub HTTPClient response with Amazon product pages 'test/fixtures/files/'
  def stub_http_request(asin)
    HTTPClient.any_instance.stubs(:get)
      .returns(stub('response', code: 200, body: read_fixture_file(asin)))
  end

  # HTTPClient expectation with Amazon product pages 'test/fixtures/files/'
  def expects_http_request(asin)
    HTTPClient.any_instance.expects(:get)
      .returns(stub('response', code: 200, body: read_fixture_file(asin)))
  end

end

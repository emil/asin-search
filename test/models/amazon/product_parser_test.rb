# coding: utf-8
require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

class Amazon::ProductParserTest < ActiveSupport::TestCase

  setup do
    # Product belongs to account, user, set in the Product#before_validation
    RequestRegistry.current_user = User.first
    RequestRegistry.current_account = User.first.account
  end

  test "ASIN fixtures" do

    asin_fixtures.each do |asin_fixture|
      product = Amazon::ProductParser.new(IO.read(asin_fixture)).product
      
      if ENV['RECORD'].present? # record mode?
        File.open(asin_fixture +'.yml', 'w' ) do |f|
          f.write(product.to_fixture_yaml)
        end
      else # verify mode
        fixture_yaml = IO.read(asin_fixture +'.yml')
        assert_equal fixture_yaml, product.to_fixture_yaml
      end

      assert product.valid? product.errors.full_messages.inspect
    end
  end
  
  private
    
  def asin_fixtures
    if ENV['ASIN'].present? # specific ASIN requested
      glob = File.join(Rails.root, 'test', 'fixtures', 'files', ENV['ASIN']).to_s
      Dir[glob]
    else # all ASIN files
      glob = File.join(Rails.root, 'test', 'fixtures', 'files', '*').to_s
      Dir[glob].grep(/[[:alnum:]]{10}\Z/)
    end
  end
end

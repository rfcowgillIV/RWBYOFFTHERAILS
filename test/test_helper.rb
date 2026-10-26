ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...
  end
end

# 2026 update: helper so tests can log in as an editor (the RWBY / DUST demo
# login, which only works in development/test).
module EditorAuthHelper
  def editor_headers(name: "RWBY", password: "DUST")
    { "HTTP_AUTHORIZATION" => ActionController::HttpAuthentication::Basic.encode_credentials(name, password) }
  end
end

class ActionDispatch::IntegrationTest
  include EditorAuthHelper
end

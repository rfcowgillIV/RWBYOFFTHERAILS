require "test_helper"

class WelcomeControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get welcome_index_url
    assert_response :success
  end

  test "home page loads" do
    get root_url
    assert_response :success
    assert_select "h1", "WELCOME TO RWBY OFF THE RAILS!"
  end

  test "the vault shows the demo login when running locally" do
    get passwords_url
    assert_response :success
    assert_match "password: DUST", response.body
  end

  test "security headers include a content security policy" do
    get root_url
    assert_match "default-src 'self'", response.headers["Content-Security-Policy"]
  end
end

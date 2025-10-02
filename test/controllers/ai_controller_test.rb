require "test_helper"

class AiControllerTest < ActionDispatch::IntegrationTest
  test "should get test" do
    get ai_test_url
    assert_response :success
  end
end

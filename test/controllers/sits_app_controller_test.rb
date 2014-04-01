require 'test_helper'

class SitsAppControllerTest < ActionController::TestCase
  test "should get app" do
    get :app
    assert_response :success
  end

end

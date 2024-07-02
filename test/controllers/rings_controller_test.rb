require "test_helper"

class RingsControllerTest < ActionDispatch::IntegrationTest
  test "that list of rings is visible" do
    ring = FactoryBot.create(:ring)
    get rings_url
    assert_response :success
  end

  test "that page without rings is working" do
    get rings_url
    assert_response :success
  end
end

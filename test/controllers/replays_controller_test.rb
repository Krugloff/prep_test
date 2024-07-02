require "test_helper"

class ReplaysControllerTest < ActionDispatch::IntegrationTest
  test "that #show redirects to fight for active fights" do
    fight = FactoryBot.create(:fight)

    get replay_url(Fight.first)
    assert_redirected_to fight_path(fight)
  end

  test "that #show returns the html page" do
    fight = FactoryBot.create(:fight, score: 100)

    get replay_url(Fight.first)
    assert_response :success
  end
end

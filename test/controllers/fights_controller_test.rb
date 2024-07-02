require "test_helper"

class FightsControllerTest < ActionDispatch::IntegrationTest
  test "that #create creates new fight" do
    ring = FactoryBot.create(:ring)

    assert_difference -> { Fight.count } do
      post fights_url, params: { fight: { ring_id: ring.id } }
    end

    assert_redirected_to fight_path(Fight.last)
  end

  test "that #create does not creates new fight for missing ring" do
    ring = FactoryBot.create(:ring)

    assert_no_difference -> { Fight.count } do
      post fights_url, params: { fight: { ring_id: 'aaaaa' } }
    end

    assert_redirected_to rings_path
    assert flash[:errors].presence
  end

  test "that #show redirects to replay for finished fights" do
    fight = FactoryBot.create(:fight, score: 100)

    get fight_url(Fight.first)
    assert_redirected_to replay_path(fight)
  end

  test "that #show returns the html page" do
    fight = FactoryBot.create(:fight)
    FactoryBot.create_list(:enemy, 2, band: fight.band)
    fight.ring.update! maximum_score: 2

    FactoryBot.create(:round, fight: Fight.first, enemy: Enemy.first)

    get fight_url(Fight.first)
    assert_response :success
  end
end

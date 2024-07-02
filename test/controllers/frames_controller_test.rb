require "test_helper"

class FramesControllerTest < ActionDispatch::IntegrationTest
  setup do
    fight = FactoryBot.create(:fight)
    FactoryBot.create_list(:enemy, 2, band: fight.band)
    fight.ring.update! maximum_score: 2
  end

  test "that #show redirects to fight for active fights" do
    FactoryBot.create(:round, fight: Fight.last, enemy: Enemy.last)

    get replay_frame_url(Fight.last, Enemy.last)
    assert_redirected_to fight_path(Fight.last)
  end

  test "that #show returns the html page" do
    Ring.last.update! maximum_score: 1
    FactoryBot.create(:round, fight: Fight.last, enemy: Enemy.last)

    get replay_frame_url(Fight.last, Enemy.last)
    assert_response :success
  end

  test "that #index redirects to fight for active fights" do
    FactoryBot.create(:round, fight: Fight.last, enemy: Enemy.last)

    get replay_frames_url(Fight.last)
    assert_redirected_to fight_path(Fight.last)
  end

  test "that #index returns the html page" do
    Ring.last.update! maximum_score: 1
    FactoryBot.create(:round, fight: Fight.last, enemy: Enemy.last)

    get replay_frames_url(Fight.last)
    assert_response :success
  end
end
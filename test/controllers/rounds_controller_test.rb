require "test_helper"

class RoundsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @fight = FactoryBot.create(:fight)
    FactoryBot.create_list(:enemy, 2, band: @fight.band).each do
      FactoryBot.create(:puppet, :correct, enemy: _1)
    end
    @fight.ring.update! maximum_score: 2
  end

  test "that #create creates new round" do
    enemy = Enemy.last

    assert_difference -> { Round.count } do
      attrs = { puppet_names: [enemy.puppets.last.name], enemy_id: enemy.id }
      post fight_rounds_url(Fight.last.id), params: { round: attrs }
    end

    assert_redirected_to fight_path(Fight.last)
  end

  test "that #create creates new round w/ given comment" do
    comment = 'TEST'
    enemy = Enemy.last

    assert_difference -> { Round.count } do
      attrs = { puppet_names: [enemy.puppets.last.name], enemy_id: enemy.id }
      post fight_rounds_url(Fight.last.id), params: { round: attrs.merge(comment: comment) } 
    end

    assert_redirected_to fight_path(Fight.last)
    assert_equal Round.last.comment, comment
  end

  test "that #create does not creates new round w/o punches" do
    enemy = Enemy.last

    assert_no_difference -> { Round.count } do
      attrs = { enemy_id: enemy.id }
      post fight_rounds_url(Fight.last.id), params: { round: attrs }
    end

    assert_redirected_to fight_path(Fight.last)
    assert flash[:errors].presence
  end

  test "that #create does not creates new round w/o required count of punches" do
    enemy = Enemy.last
    FactoryBot.create(:puppet, :correct, enemy: enemy)

    assert_no_difference -> { Round.count } do
      attrs = { puppet_names: [enemy.puppets.last.name], enemy_id: enemy.id }
      post fight_rounds_url(Fight.last.id), params: { round: attrs }
    end

    assert_redirected_to fight_path(Fight.last)
    assert flash[:errors].presence
  end

  test "that #create updates fight score on the final round" do
    enemy = Enemy.last
    @fight.ring.update! maximum_score: 1

    assert_difference -> { Round.count } do
      attrs = { puppet_names: [enemy.puppets.last.name], enemy_id: enemy.id }
      post fight_rounds_url(Fight.last.id), params: { round: attrs }
    end

    assert_redirected_to fight_path(Fight.last)
    assert Fight.last.score
  end
end
require "test_helper"

class RoundTest < ActiveSupport::TestCase
  test "that factory is valid" do  
    round = FactoryBot.build(:round)
    assert round.save
  end

  %i(enemy enemy_id fight fight_id).each do |attr_name|
    test "that ##{attr_name} is required on create" do
      round = FactoryBot.build(:round, attr_name => nil)
      assert_not round.save
    end

    test "that ##{attr_name} is required on update" do
      round = FactoryBot.create(:round)
      assert_not round.update(attr_name => nil)
    end
  end

  test 'that #puppet_names= update puppets' do
    round = FactoryBot.create(:round)
    puppet = FactoryBot.create(:puppet, enemy: round.enemy)
    round.puppet_names = [puppet.name]
    round.save!
    # TODO: for some reasons puppets.pluck(:id) returns weird records
    assert_equal round.puppets.pluck(:name), [puppet.name]
  end

  test 'that #puppet_names= creates new punches' do
    round = FactoryBot.create(:round)
    puppets = FactoryBot.create_list(:puppet, 3, :correct, enemy: round.enemy)
    round.enemy.reload
    
    # TODO: for some reasons round.reload.punches returns no changes
    assert_changes -> { round.punches.to_a } do
      round.puppet_names = round.enemy.puppets.correct.map(&:name)
      round.save!
    end
  end

  test 'that #puppet_names= removes old punches' do
    round = FactoryBot.create(:round)
    # TODO: for some reasons punches will keep the link to relation not a records (w/o to_a)
    punches = round.punches.to_a

    puppets = FactoryBot.create_list(:puppet, 3, :correct, enemy: round.enemy)
    round.enemy.reload
    
    round.puppet_names = round.enemy.puppets.correct.map(&:name)
    round.save!
  
    assert_raise(ActiveRecord::RecordNotFound) do
      punches.each(&:reload)
    end
  end

  test 'that #puppet_names returns array of names' do
    round = FactoryBot.create(:round)
    assert_equal round.puppet_names, round.puppets.map(&:name)
  end

  test 'that #win? returns true if all of punched puppets are correct' do
    round = FactoryBot.create(:round, :win)
    assert_equal round.puppets.map(&:correct).uniq, [true]
    assert round.win?
  end

  test 'that #win? returns true if any of punched puppets are incorrect' do
    round = FactoryBot.create(:round)
    assert_equal round.puppets.map(&:correct).uniq, [false]
    assert_not round.win?
  end

  test "that #update_score do nothing if punched enemies is not enough" do
    fight = FactoryBot.create(:fight)
    enemies = FactoryBot.create_list(:enemy, 2, band: fight.ring.band)
    fight.ring.update! maximum_score: 2

    FactoryBot.create(:round, :win, fight: fight, enemy: enemies.last)
   
    assert_not fight.reload.score
  end

  test "that #update_score will count the score correctly" do
    fight = FactoryBot.create(:fight)
    enemies = FactoryBot.create_list(:enemy, 2, band: fight.ring.band)
    fight.ring.update! maximum_score: 2

    FactoryBot.create(:round, fight: Fight.first, enemy: enemies.first)
    FactoryBot.create(:round, :win, fight: Fight.first, enemy: enemies.last)

    assert fight.reload.score, 50
  end

  test "that #punches_count should be equal to enemy hp" do
    round = FactoryBot.create(:round)

    assert_changes -> { round.reload.valid? } do
      # change the hp through new correct puppet creation
      FactoryBot.create(:puppet, :correct, enemy: round.enemy)
    end
  end

  test "that round can not be create twice for same fight" do
    round = FactoryBot.create(:round)

    assert_raise(ActiveRecord::RecordNotUnique) do
      FactoryBot.create(:round, fight: round.fight, enemy: round.enemy)
    end
  end

  test "that round will be destroyed with a fight" do
    round = FactoryBot.create(:round)

    assert_changes -> { Round.count } do
      round.fight.destroy
    end
  end

  test "that round will be deleted with a fight" do
    round = FactoryBot.create(:round)

    assert_changes -> { Round.count } do
      round.fight.delete
    end
  end

  test "that all rounds will be deleted with a fight" do
    round = FactoryBot.create(:round)

    assert_changes -> { Round.count } do
      Fight.delete_all
    end
  end

  test "that all rounds will be destroyed with a fight" do
    round = FactoryBot.create(:round)

    assert_changes -> { Round.count } do
      Fight.destroy_all
    end
  end
end
require "test_helper"

class FightTest < ActiveSupport::TestCase
  test "that factory is valid" do  
    fight = FactoryBot.build(:fight)
    assert fight.save
  end

  %i(ring ring_id).each do |attr_name|
    test "that ##{attr_name} is required on create" do
      fight = FactoryBot.build(:fight, attr_name => nil)
      assert_not fight.save
    end

    test "that ##{attr_name} is required on update" do
      fight = FactoryBot.create(:fight)
      assert_not fight.update(attr_name => nil)
    end
  end

  test "that #score can not be greater than 100 percents on create" do
    fight = FactoryBot.build(:fight, score: 101)
    assert_not fight.save
  end

  test "that #score can not be greater than 100 percents on update" do
    fight = FactoryBot.create(:fight)
    assert_not fight.update(score: 101)
  end

  test "that #current_enemy returns possible enemies" do
    fight = FactoryBot.create(:fight)
    FactoryBot.create(:enemy, band: fight.band)
    assert fight.possible_enemies.presence
    assert_not fight.smashed_enemies.presence

    assert fight.current_enemy
  end

  test "that #current_enemy does not return smashed enemies" do
    fight = FactoryBot.create(:fight)
    FactoryBot.create(:round, fight: fight)
    assert fight.possible_enemies.presence
    assert fight.smashed_enemies.presence

    assert_not fight.current_enemy
  end

  test "that ring with existing fights can not be removed" do
    fight = FactoryBot.create(:fight)
    assert_not fight.ring.destroy

    assert_raise(ActiveRecord::InvalidForeignKey) do
      fight.ring.delete
    end

    assert_no_difference -> { Ring.count } do
      Ring.destroy_all
    end

    assert_raise(ActiveRecord::InvalidForeignKey) do
      Ring.delete_all
    end
  end
end

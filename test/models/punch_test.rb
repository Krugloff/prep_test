require "test_helper"

class PunchTest < ActiveSupport::TestCase
  %i(fight fight_id enemy enemy_id puppet_name).each do |attr_name|
    test "that ##{attr_name} is required on create" do
      round = FactoryBot.create(:round)
      puppet = FactoryBot.create(:puppet, enemy: round.enemy)
      attrs = { 
        fight: round.fight,
        enemy: round.enemy,
        puppet_name: puppet.name 
      }

      assert_not Punch.create(attrs.merge(attr_name => nil)).id
      assert Punch.create(attrs).id # just want to be sure
    end
    
    test "that ##{attr_name} is required on update" do
      round = FactoryBot.create(:round)
      assert_not Punch.last.update(attr_name => nil)
    end
  end

  test "that is not possible to punch one puppet twice" do
    round = FactoryBot.create(:round)
    puppet_name = round.punches.first.puppet_name
    assert_raise(ActiveRecord::RecordNotUnique) do
      Punch.create(enemy: round.enemy, fight: round.fight, puppet_name:).id
    end
  end

  test "that is not possible to punch missing puppet" do
    round = FactoryBot.create(:round)
    assert_not Punch.create(enemy: round.enemy, fight: round.fight, puppet_name: 'hacker').id
  end

  # since foreign key is here
  test "that punched puppet can not be removed" do
    round = FactoryBot.create(:round)

    assert_raise(ActiveRecord::InvalidForeignKey) do
      round.puppets.first.destroy
    end

    assert_raise(ActiveRecord::InvalidForeignKey) do
      round.puppets.first.delete
    end

    assert_raise(ActiveRecord::InvalidForeignKey) do
      Puppet.destroy_all
    end

    assert_raise(ActiveRecord::InvalidForeignKey) do
      Puppet.delete_all
    end
  end

  test "that punches will be destroyed with a round" do
    round = FactoryBot.create(:round)

    assert_changes -> { Punch.count } do
      round.destroy
    end
  end

  test "that punches will be deleted with a round" do
    round = FactoryBot.create(:round)

    assert_changes -> { Punch.count } do
      round.delete
    end
  end

  test "that all punches will be deleted with a round" do
    round = FactoryBot.create(:round)

    assert_changes -> { Punch.count } do
      Round.delete_all
    end
  end

  test "that all punches will be destroyed with a round" do
    round = FactoryBot.create(:round)

    assert_changes -> { Punch.count } do
      Round.destroy_all
    end
  end
end
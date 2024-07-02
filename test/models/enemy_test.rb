require "test_helper"

class EnemyTest < ActiveSupport::TestCase
  test "that factory is valid" do  
    enemy = FactoryBot.build(:enemy)
    assert enemy.save
  end

  %i(band band_id title comment language).each do |attr_name|
    test "that ##{attr_name} is required on create" do
      enemy = FactoryBot.build(:enemy, attr_name => nil)
      assert_not enemy.save
    end

    test "that ##{attr_name} is required on update" do
      enemy = FactoryBot.create(:enemy)
      assert_not enemy.update(attr_name => nil)
    end
  end

  test "that language is limited on create" do
    enemy = FactoryBot.build(:enemy, language: :fr)
    assert_not enemy.save
  end

  test "that language is limited on update" do
    enemy = FactoryBot.create(:enemy)
    assert_not enemy.update(language: :fr)
  end

  test "that #hp count only correct puppets" do
    enemy = FactoryBot.create(:enemy)
    FactoryBot.create_list(:puppet, 2, enemy: enemy)
    FactoryBot.create_list(:puppet, 3, :correct, enemy: enemy)
    assert_equal enemy.hp, 3
  end

  %i(body comment).each do |meth_name|
    test "that #html_#{meth_name} convert markdown to html" do
      enemy = FactoryBot.create(:enemy, meth_name => '# header1')
      assert_equal enemy.send("html_#{meth_name}"), "<h1>header1</h1>\n"
    end
  end

  test "that #html_title convert text to html h1" do
    enemy = FactoryBot.create(:enemy, title: 'header1')
    assert_equal enemy.html_title, "<h1>header1</h1>\n"
  end

  test "that #html_body convert blank values to nothing" do
    enemy = FactoryBot.create(:enemy, body: nil)
    assert_equal enemy.html_body, ""
  end

  # put it here since we add has many association to enemy model
  # even if foreign key in round model
  test "that enemy with existing fights can not be removed" do
    fight = FactoryBot.create(:fight)
    round = FactoryBot.create(:round, fight: fight)

    assert_raise(ActiveRecord::InvalidForeignKey) do
      round.enemy.destroy
    end

    assert_raise(ActiveRecord::InvalidForeignKey) do
      round.enemy.delete
    end

    assert_raise(ActiveRecord::InvalidForeignKey) do
      Enemy.destroy_all
    end

    assert_raise(ActiveRecord::InvalidForeignKey) do
      Enemy.delete_all
    end
  end

  test "that enemy will be destroyed with a band" do
    enemy = FactoryBot.create(:enemy)

    assert_changes -> { Enemy.count } do
      enemy.band.destroy
    end
  end

  test "that enemy will be deleted with a band" do
    enemy = FactoryBot.create(:enemy)

    assert_changes -> { Enemy.count } do
      enemy.band.delete
    end
  end

  test "that all enemies will be deleted with a band" do
    enemy = FactoryBot.create(:enemy)

    assert_changes -> { Enemy.count } do
      Band.delete_all
    end
  end

  test "that all enemies will be destroyed with a band" do
    enemy = FactoryBot.create(:enemy)

    assert_changes -> { Enemy.count } do
      Band.destroy_all
    end
  end
end

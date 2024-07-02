require "test_helper"

class PuppetTest < ActiveSupport::TestCase
  test "that factory is valid" do  
    puppet = FactoryBot.build(:puppet)
    assert puppet.save
  end

  %i(enemy enemy_id name body).each do |attr_name|
    test "that ##{attr_name} is required on create" do
      puppet = FactoryBot.build(:puppet, attr_name => nil)
      assert_not puppet.save
    end

    test "that ##{attr_name} is required on update" do
      puppet = FactoryBot.create(:puppet)
      assert_not puppet.update(attr_name => nil)
    end
  end

  test "that ::correct returns only records with positive flag" do
    FactoryBot.create_list(:puppet, 2)
    FactoryBot.create_list(:puppet, 3, :correct)
    assert_equal Puppet.correct.count, 3
  end

  test "that #html_body convert markdown to html" do
    puppet = FactoryBot.create(:puppet, body: '# header1')
    assert_equal puppet.html_body, "<h1>header1</h1>\n"
  end

  test "that puppet name should be unique for an enemy" do
    puppet = FactoryBot.create(:puppet)

    assert_raise(ActiveRecord::RecordNotUnique) do
      FactoryBot.create(:puppet, enemy: puppet.enemy, name: puppet.name)
    end
  end

  test "that puppets will be destroyed with an enemy" do
    puppet = FactoryBot.create(:puppet)

    assert_changes -> { Puppet.count } do
      puppet.enemy.destroy
    end
  end

  test "that puppets will be deleted with an enemy" do
    puppet = FactoryBot.create(:puppet)

    assert_changes -> { Puppet.count } do
      puppet.enemy.delete
    end
  end

  test "that all puppets will be deleted with an enemy" do
    puppet = FactoryBot.create(:puppet)

    assert_changes -> { Puppet.count } do
      Enemy.delete_all
    end
  end

  test "that all puppets will be destroyed with an enemy" do
    puppet = FactoryBot.create(:puppet)

    assert_changes -> { Puppet.count } do
      Enemy.destroy_all
    end
  end
end

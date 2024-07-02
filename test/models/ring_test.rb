require "test_helper"

class RingTest < ActiveSupport::TestCase
  test "that factory is valid" do  
    ring = FactoryBot.build(:ring)
    assert ring.save
  end

  %i(band band_id maximum_score treshold).each do |attr_name|
    test "that ##{attr_name} is required on create" do
      ring = FactoryBot.build(:ring, attr_name => nil)
      assert_not ring.save
    end

    test "that ##{attr_name} is required on update" do
      ring = FactoryBot.create(:ring)
      assert_not ring.update(attr_name => nil)
    end
  end

  test "that #treshold can not be greater than 100 percent on create" do
    ring = FactoryBot.build(:ring, treshold: 101)
    assert_not ring.save
  end

  test "that #treshold can not be greater than 100 percent on update" do
    ring = FactoryBot.create(:ring)
    assert_not ring.update(treshold: 101)
  end

  test "that #maximum_score can not be greater than band enemies count" do
    ring = FactoryBot.create(:ring)
    # TODO: what will happens if enemy has been deleted after creating a ring?
    FactoryBot.create_list(:enemy, 2, band: ring.band)
    assert_not ring.update(maximum_score: 3)
    assert ring.update(maximum_score: 2)
  end

  test "that ring will be destroyed with a band" do
    ring = FactoryBot.create(:ring)

    assert_changes -> { Ring.count } do
      ring.band.destroy
    end
  end

  test "that ring will be deleted with a band" do
    ring = FactoryBot.create(:ring)

    assert_changes -> { Ring.count } do
      ring.band.delete
    end
  end

  test "that all rings will be deleted with a band" do
    ring = FactoryBot.create(:ring)

    assert_changes -> { Ring.count } do
      Band.delete_all
    end
  end

  test "that all rings will be destroyed with a band" do
    ring = FactoryBot.create(:ring)

    assert_changes -> { Ring.count } do
      Band.destroy_all
    end
  end
end

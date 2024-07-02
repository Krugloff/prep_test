require "test_helper"

class BandTest < ActiveSupport::TestCase
  test 'that factory is valid' do
    band = FactoryBot.build(:band)
    assert band.save
  end

  test "that name is required on create" do
    band = FactoryBot.build(:band, name: nil)
    assert_not band.save
  end

  test "that name is required on update" do
    band = FactoryBot.create(:band)
    assert_not band.update(name: nil)
  end
end

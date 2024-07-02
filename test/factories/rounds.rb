FactoryBot.define do
  factory :round do
    fight { FactoryBot.create(:fight) }
    enemy { fight ? FactoryBot.create(:enemy, band: fight.band) : FactoryBot.create(:enemy) }
    
    puppet_names do
      [
        FactoryBot.create(:puppet, :correct, enemy_id: enemy_id),
        FactoryBot.create(:puppet, enemy_id: enemy_id)
      ].reject(&:correct?).map(&:name)
    rescue ActiveRecord::RecordInvalid
      []
    end

    comment { "Round Comment #{_1}" }

    trait :win do
      puppet_names do 
        [
          FactoryBot.create(:puppet, :correct, enemy_id: enemy_id),
          FactoryBot.create(:puppet, enemy_id: enemy_id)
        ].select(&:correct?).map(&:name)
      rescue ActiveRecord::RecordInvalid
        []
      end
    end
  end
end
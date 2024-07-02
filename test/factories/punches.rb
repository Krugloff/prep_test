FactoryBot.define do
  factory :punch do
    round { FactoryBot.create(:round) }
    enemy { round.enemy }
    fight { round.fight }

    puppet_name { round.enemy }
    round { FactoryBot.create(:round, fight: fight, enemy: enemy, puppets: [self]) }

    puppet do 
      [
        association(:puppet, enemy_id: enemy.id),
        association(:puppet, :correct, enemy_id: enemy.id) 
      ].first
    end

    trait :correct do
      puppet do 
        [
          association(:puppet, enemy_id: enemy.id),
          association(:puppet, :correct, enemy_id: enemy.id) 
      ].last
      end
    end
  end
end
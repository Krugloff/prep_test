FactoryBot.define do
  factory :puppet do
    enemy
    sequence(:name) { (?a..?z).to_a[_1 % 26] }
    sequence(:body) { "Puppet body #{_1}" }
    correct { false }

    trait :correct do
      correct { true }
    end
  end
end
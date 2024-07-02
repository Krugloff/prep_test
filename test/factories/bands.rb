FactoryBot.define do
  factory :band do
    sequence(:name) { "Band #{_1}" }
  end
end
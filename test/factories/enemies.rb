FactoryBot.define do
  factory :enemy do
    band
    language { 'en' }
    sequence(:title) { "Enemy title #{_1}" }
    sequence(:body) { "Enemy body #{_1}" }
    sequence(:comment) { "Enemy comment #{_1}" }
  end
end
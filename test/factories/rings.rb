FactoryBot.define do
  factory :ring do
    band
    maximum_score { 0 } # since there is no enemies yet
    treshold { 75 }
  end
end
FactoryBot.define do
  factory :item do
    name { Faker::Appliance.equipment }
    description { Faker::Lorem.sentence }
    unit_price { Faker::Number.between(from = 1.00, to = 100.00) }
    association :merchant
  end
end

FactoryBot.define do
  factory :item do
    name { Faker::Appliance.equipment }
    description { Faker::Lorem.sentence }
    unit_price { Faker::Commerce.price }
    association :merchant
  end
end

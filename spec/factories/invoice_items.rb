FactoryBot.define do
  factory :invoice_item do
    item { nil }
    invoice { nil }
    quantity { 1 }
    unit_price { Faker::Number.between(from = 1.00, to = 100.00) }
  end
end

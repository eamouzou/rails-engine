FactoryBot.define do
  factory :transaction do
    invoice { nil }
    credit_card_number { Faker::Business.credit_card_number.delete("-") }
    credit_card_expiration_date { Faker::Business.credit_card_expiry_date.to_s }
    result { "success" }
  end
end

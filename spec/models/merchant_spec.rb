require 'rails_helper'

RSpec.describe Merchant, type: :model do
  describe 'relationships' do
    it {should have_many :items}
    it {should have_many :invoices}
    it {should have_many(:invoice_items).through(:invoices)}
    it {should have_many(:transactions).through(:invoices)}
  end

  describe 'class methods' do
    before(:each) do
      @merchant1 = create(:merchant, name: 'merchant1')
      @merchant2 = create(:merchant, name: 'merchant2')
      @merchant3 = create(:merchant, name: 'merchant3')

      item1 = create(:item, merchant: @merchant1, name: "Car Shoes", unit_price: 67.22, description: "NIghtly use", created_at: "2020-03-21 01:00:00 UTC", updated_at: "2020-03-21 01:17:08 UTC")
      item2 = create(:item, merchant: @merchant1, name: "Tire", unit_price: 32.32, description: "interesting", created_at: "2020-03-21 01:00:00 UTC", updated_at: "2020-03-21 01:17:08 UTC")
      item3 = create(:item, merchant: @merchant2, name: "Wheel", unit_price: 90.72, description: "All weather", created_at: "2020-03-21 01:00:00 UTC", updated_at: "2020-03-21 01:17:08 UTC")
      item4 = create(:item, merchant: @merchant2, name: "Brake pad", unit_price: 14.28, description: "brand new", created_at: "2020-03-21 01:00:00 UTC", updated_at: "2020-03-21 01:17:08 UTC")
      item5 = create(:item, merchant: @merchant3, name: "Shoes", unit_price: 30.87, description: "black and white", created_at: "2020-03-21 01:00:00 UTC", updated_at: "2020-03-21 01:17:08 UTC")
      item6 = create(:item, merchant: @merchant3, name: "Socks", unit_price: 123.76, description: "no holes", created_at: "2020-03-21 01:00:00 UTC", updated_at: "2020-03-21 01:17:08 UTC")

      customer1 = create(:customer, first_name: 'First', last_name: 'Last')
      customer2 = create(:customer, first_name: 'Second', last_name: 'Last')

      invoice1 = create(:invoice, customer: customer1, merchant: @merchant1)
      invoice2 = create(:invoice, customer: customer1, merchant: @merchant2)
      invoice3 = create(:invoice, customer: customer1, merchant: @merchant3)
      invoice4 = create(:invoice, customer: customer2, merchant: @merchant3)

      invoice_item1 = create(:invoice_item, item: item1, invoice: invoice1, quantity: 7, unit_price: item1.unit_price)
      invoice_item2 = create(:invoice_item, item: item2, invoice: invoice1, quantity: 12, unit_price: item2.unit_price)
      invoice_item3 = create(:invoice_item, item: item3, invoice: invoice2, quantity: 27, unit_price: item3.unit_price)
      invoice_item4 = create(:invoice_item, item: item4, invoice: invoice2, quantity: 9, unit_price: item4.unit_price)
      invoice_item5 = create(:invoice_item, item: item5, invoice: invoice3, quantity: 32, unit_price: item5.unit_price)
      invoice_item6 = create(:invoice_item, item: item6, invoice: invoice3, quantity: 21, unit_price: item6.unit_price)
      invoice_item7 = create(:invoice_item, item: item6, invoice: invoice4, quantity: 15, unit_price: item6.unit_price)

      transaction1 = create(:transaction, invoice: invoice1)
      transaction2 = create(:transaction, invoice: invoice2)
      transaction3 = create(:transaction, invoice: invoice3)
      transaction4 = create(:transaction, invoice: invoice4, result: "failed")
    end

    it '#most_revenue' do
      result = [@merchant1, @merchant2]
      method_result = Merchant.most_revenue(2)
      expect(method_result.first.id).to eq(result.first.id)
      expect(method_result.second.id).to eq(result.second.id)
    end

    it '#most_items' do
      expected_result = [@merchant3, @merchant2]
      method_result = Merchant.most_items(2)
      expect(method_result).to eq(expected_result)
      expect(method_result.first.total_amount).to eq(53)
      expect(method_result.second.total_amount).to eq(36)
    end

    it '#revenue_by_dates' do
      start = "2020-03-18"
      finish = "2020-03-19"
      expect(Merchant.revenue_by_dates(start, finish).class).to eq(Float)
    end

    it '#revenue' do
      result = Merchant.revenue(Merchant.where(id: @merchant3.id))
      expect(result.class).to eq(Float)
    end
  end
end

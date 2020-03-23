require 'rails_helper'

describe 'Merchants API' do
  before(:each) do
    @merchant1 = create(:merchant, name: 'merchant1')
    @merchant2 = create(:merchant, name: 'merchant2')
    @merchant3 = create(:merchant, name: 'merchant3')

    @item1 = create(:item, merchant: @merchant1, name: "Car Shoes", unit_price: 30.45, description: "NIghtly use", created_at: "2020-03-21 01:00:00 UTC", updated_at: "2020-03-21 01:17:08 UTC")
    @item2 = create(:item, merchant: @merchant1, name: "Tire", unit_price: 15.20, description: "interesting", created_at: "2020-03-21 01:00:00 UTC", updated_at: "2020-03-21 01:17:08 UTC")
    @item3 = create(:item, merchant: @merchant2, name: "Wheel", unit_price: 65.00, description: "All weather", created_at: "2020-03-21 01:00:00 UTC", updated_at: "2020-03-21 01:17:08 UTC")
    @item4 = create(:item, merchant: @merchant2, name: "Brake pad", unit_price: 26.72, description: "brand new", created_at: "2020-03-21 01:00:00 UTC", updated_at: "2020-03-21 01:17:08 UTC")
    @item5 = create(:item, merchant: @merchant3, name: "Shoes", unit_price: 30.87, description: "black and white", created_at: "2020-03-21 01:00:00 UTC", updated_at: "2020-03-21 01:17:08 UTC")
    @item6 = create(:item, merchant: @merchant3, name: "Socks", unit_price: 123.76, description: "no holes", created_at: "2020-03-21 01:00:00 UTC", updated_at: "2020-03-21 01:17:08 UTC")

    @customer1 = create(:customer, first_name: 'First', last_name: 'Last')
    @customer2 = create(:customer, first_name: 'Second', last_name: 'Last')

    @invoice1 = create(:invoice, customer: @customer1, merchant: @merchant1)
    @invoice2 = create(:invoice, customer: @customer1, merchant: @merchant2)
    @invoice3 = create(:invoice, customer: @customer1, merchant: @merchant3)
    @invoice4 = create(:invoice, customer: @customer2, merchant: @merchant3)

    @invoice_item1 = create(:invoice_item, item: @item1, invoice: @invoice1, quantity: 7, unit_price: @item1.unit_price)
    @invoice_item2 = create(:invoice_item, item: @item2, invoice: @invoice1, quantity: 12, unit_price: @item2.unit_price)
    @invoice_item3 = create(:invoice_item, item: @item3, invoice: @invoice2, quantity: 27, unit_price: @item3.unit_price)
    @invoice_item4 = create(:invoice_item, item: @item4, invoice: @invoice2, quantity: 9, unit_price: @item4.unit_price)
    @invoice_item5 = create(:invoice_item, item: @item5, invoice: @invoice3, quantity: 32, unit_price: @item5.unit_price)
    @invoice_item6 = create(:invoice_item, item: @item6, invoice: @invoice3, quantity: 21, unit_price: @item6.unit_price)
    @invoice_item7 = create(:invoice_item, item: @item6, invoice: @invoice4, quantity: 15, unit_price: @item6.unit_price)

    @transaction1 = create(:transaction, invoice: @invoice1)
    @transaction2 = create(:transaction, invoice: @invoice2)
    @transaction3 = create(:transaction, invoice: @invoice3)
    @transaction4 = create(:transaction, invoice: @invoice4, result: "failed")
  end

  it 'sends a list of merchants' do
    get '/api/v1/merchants'

    expect(response).to be_successful

    merchants = JSON.parse(response.body)

    expect(merchants['data'].count).to eq(3)
  end

  it 'can get a merchant by its id' do
    merchant = create(:merchant)
    id = merchant.id
    name = merchant.name

    get "/api/v1/merchants/#{id}"

    merchant = JSON.parse(response.body)

    expect(response).to be_successful
    expect(merchant['data']['id'].to_i).to eq(id)
    expect(merchant['data']['attributes']['name']).to eq(name)
  end

  it "can create a merchant" do
    merchant_params = {name: "Bolingo"}

    post "/api/v1/merchants", params: {merchant: merchant_params}

    merchant = Merchant.last
    parsed_merchant = JSON.parse(response.body)

    expect(response).to be_successful
    expect(merchant.name).to eq(merchant_params[:name])
    expect(parsed_merchant['data']['attributes']).to eq({"id" => merchant.id, "name" => merchant.name})
  end

  it "can update" do
    id = create(:merchant).id
    previous_name = Merchant.last.name
    merchant_params = { name: "Manu"}

    put "/api/v1/merchants/#{id}", params: {merchant: merchant_params}
    merchant = Merchant.find_by(id: id)
    parsed_merchant = JSON.parse(response.body)


    expect(response).to be_successful
    expect(merchant.name).to_not eq(previous_name)
    expect(merchant.name).to eq("Manu")
    expect(parsed_merchant['data']['attributes']).to eq({"id" => id, "name" => "Manu"})
  end

  it "can destroy a merchant" do
    merchant = create(:merchant)
    id = merchant.id
    name = merchant.name

    expect(Merchant.count).to eq(4)

    delete "/api/v1/merchants/#{merchant.id}"
    parsed_merchant = JSON.parse(response.body)


    expect(response).to be_successful
    expect(Merchant.count).to eq(3)
    expect{Merchant.find(merchant.id)}.to raise_error(ActiveRecord::RecordNotFound)
    expect(parsed_merchant['data']['attributes']).to eq({"id" => id, "name" => name})
  end

  it "can find merchants by most revenue" do

    get '/api/v1/merchants/most_revenue?quantity=2'

    expect(response).to be_successful
    parsed_merchants = JSON.parse(response.body)
    expect(parsed_merchants["data"].count).to eq(2)
    expect(parsed_merchants["data"].first["id"]).to eq(@merchant3.id.to_s)
    expect(parsed_merchants["data"].second["id"]).to eq(@merchant2.id.to_s)
  end


end

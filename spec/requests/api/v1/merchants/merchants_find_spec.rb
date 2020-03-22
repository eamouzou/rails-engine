require 'rails_helper'

describe 'Merchants Find Requests' do
  before(:each) do
    @merchant_1 = create(:merchant)
    @merchant_2 = create(:merchant, name: "Merchant Quidem Suscipit")
    @merchant_3 = create(:merchant, name: "Merchant Quidem Suscipit")
  end

  it 'returns merchant with given id' do
    get "/api/v1/merchants/find?id=#{@merchant_1.id}"

    parsed_merchant = JSON.parse(response.body)

    expect(response).to be_successful
    expect(parsed_merchant["data"]["attributes"]["id"]).to eq(@merchant_1.id)
    expect(parsed_merchant["data"]["attributes"]["name"]).to eq(@merchant_1.name)
  end

  it 'returns merchant with given name' do
    get "/api/v1/merchants/find?name=#{@merchant_3.name}"

    parsed_merchant = JSON.parse(response.body)

    expect(response).to be_successful
    expect(parsed_merchant["data"]["attributes"]["id"]).to eq(@merchant_2.id)
    expect(parsed_merchant["data"]["attributes"]["name"]).to eq(@merchant_2.name)
  end

  it 'returns merchant with given partial name' do
    name = @merchant_3.name
    partial_name = name[0..-3].downcase
    get "/api/v1/merchants/find?name=#{partial_name}"

    parsed_merchant = JSON.parse(response.body)


    expect(response).to be_successful
    expect(parsed_merchant["data"]["attributes"]["id"]).to eq(@merchant_2.id)
    expect(parsed_merchant["data"]["attributes"]["name"]).to eq(@merchant_2.name)
  end

  it 'returns merchant with given created timestamp' do
    merchant = create(:merchant, created_at: "2020-03-21 01:00:00 UTC", updated_at: "2020-03-21 01:17:08 UTC")

    get "/api/v1/merchants/find?created_at=#{merchant.created_at}"


    parsed_merchant = JSON.parse(response.body)

    expect(response).to be_successful
    expect(parsed_merchant["data"]["attributes"]["id"]).to eq(merchant.id)
    expect(parsed_merchant["data"]["attributes"]["name"]).to eq(merchant.name)
  end

  it 'returns Merchant with given updated timestamp' do
    merchant = create(:merchant, created_at: "2020-03-21 01:00:00 UTC", updated_at: "2020-03-21 01:17:08 UTC")

    get "/api/v1/merchants/find?updated_at=#{merchant.updated_at}"

    parsed_merchant = JSON.parse(response.body)

    expect(response).to be_successful
    expect(parsed_merchant["data"]["attributes"]["id"]).to eq(merchant.id)
    expect(parsed_merchant["data"]["attributes"]["name"]).to eq(merchant.name)
  end

  it "returns merchant when given multiple attributes including partial values" do
    merchant = create(:merchant, name: "Car Sellers", created_at: "2020-03-21 01:00:00 UTC", updated_at: "2020-03-21 01:17:08 UTC")
    merchant1 = create(:merchant, name: "Bike Sellers", created_at: "2020-03-21 01:00:00 UTC", updated_at: "2020-03-21 01:17:08 UTC")
    merchant2 = create(:merchant, name: "Tire Sellers", created_at: "2020-03-21 01:00:00 UTC", updated_at: "2020-03-21 01:17:08 UTC")
    merchant3 = create(:merchant, name: "Car Sales", created_at: "2020-03-22 01:00:00 UTC", updated_at: "2020-03-22 01:17:08 UTC")

    get "/api/v1/merchants/find?name=car&updated_at=#{merchant.updated_at}"

    parsed_merchant = JSON.parse(response.body)

    expect(response).to be_successful
    expect(parsed_merchant["data"]["attributes"]["id"]).to eq(merchant.id)
    expect(parsed_merchant["data"]["attributes"]["name"]).to eq(merchant.name)
  end

end

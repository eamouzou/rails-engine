require 'rails_helper'

describe 'Merchants Find All Requests' do
  before(:each) do
    @merchant_1 = create(:merchant)
    @merchant_2 = create(:merchant, name: "Merchant Quidem Suscipit")
    @merchant_3 = create(:merchant, name: "Merchant Quidem Suscipit")
  end

  it 'returns merchants with given name' do
    get "/api/v1/merchants/find_all?name=#{@merchant_3.name}"

    parsed_merchants = JSON.parse(response.body)

    expect(response).to be_successful
    expect(parsed_merchants["data"].count).to eq(2)
    expect(parsed_merchants["data"].first["attributes"]["id"]).to eq(@merchant_2.id)
    expect(parsed_merchants["data"].second["attributes"]["id"]).to eq(@merchant_3.id)
  end

  it 'returns merchants with given partial name' do
    name = @merchant_3.name
    partial_name = name[0..-3].downcase
    get "/api/v1/merchants/find_all?name=#{partial_name}"

    parsed_merchants = JSON.parse(response.body)


    expect(response).to be_successful
    expect(parsed_merchants["data"].count).to eq(2)
    expect(parsed_merchants["data"].first["attributes"]["id"]).to eq(@merchant_2.id)
    expect(parsed_merchants["data"].second["attributes"]["id"]).to eq(@merchant_3.id)
  end

  it 'returns merchants with given created timestamp' do
    merchant1 = create(:merchant, created_at: "2020-03-21 01:00:00 UTC", updated_at: "2020-03-21 01:17:08 UTC")
    merchant2 = create(:merchant, created_at: "2020-03-21 01:00:00 UTC", updated_at: "2020-03-21 01:17:08 UTC")
    merchant3 = create(:merchant, created_at: "2020-03-21 01:00:00 UTC", updated_at: "2020-03-21 01:17:08 UTC")

    get "/api/v1/merchants/find_all?created_at=#{merchant3.created_at}"

    parsed_merchants = JSON.parse(response.body)

    expect(response).to be_successful
    expect(parsed_merchants["data"].count).to eq(3)
    expect(parsed_merchants["data"].first["attributes"]["id"]).to eq(merchant1.id)
    expect(parsed_merchants["data"].second["attributes"]["id"]).to eq(merchant2.id)
    expect(parsed_merchants["data"].third["attributes"]["id"]).to eq(merchant3.id)
  end

  it 'returns merchants with given updated timestamp' do
    merchant1 = create(:merchant, created_at: "2020-03-21 01:00:00 UTC", updated_at: "2020-03-21 01:17:08 UTC")
    merchant2 = create(:merchant, created_at: "2020-03-21 01:00:00 UTC", updated_at: "2020-03-21 01:17:08 UTC")
    merchant3 = create(:merchant, created_at: "2020-03-21 01:00:00 UTC", updated_at: "2020-03-21 01:17:08 UTC")

    get "/api/v1/merchants/find_all?updated_at=#{merchant2.updated_at}"

    parsed_merchants = JSON.parse(response.body)

    expect(response).to be_successful
    expect(parsed_merchants["data"].count).to eq(3)
    expect(parsed_merchants["data"].first["attributes"]["id"]).to eq(merchant1.id)
    expect(parsed_merchants["data"].second["attributes"]["id"]).to eq(merchant2.id)
    expect(parsed_merchants["data"].third["attributes"]["id"]).to eq(merchant3.id)
  end

  it "returns merchants when given multiple attributes including partial values" do
    merchant1 = create(:merchant, name: "Car Sellers", created_at: "2020-03-21 01:00:00 UTC", updated_at: "2020-03-21 01:17:08 UTC")
    merchant2 = create(:merchant, name: "Bike Sellers", created_at: "2020-03-21 01:00:00 UTC", updated_at: "2020-03-21 01:17:08 UTC")
    merchant3 = create(:merchant, name: "Tire Sellers", created_at: "2020-03-21 01:00:00 UTC", updated_at: "2020-03-21 01:17:08 UTC")
    merchant4 = create(:merchant, name: "Car Sales", created_at: "2020-03-22 01:00:00 UTC", updated_at: "2020-03-22 01:17:08 UTC")

    get "/api/v1/merchants/find_all?name=car&updated_at=#{merchant4.updated_at}"

    parsed_merchants = JSON.parse(response.body)

    expect(response).to be_successful
    expect(parsed_merchants["data"].count).to eq(2)
    expect(parsed_merchants["data"].first["attributes"]["id"]).to eq(merchant1.id)
    expect(parsed_merchants["data"].second["attributes"]["id"]).to eq(merchant4.id)
  end

end

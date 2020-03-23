require 'rails_helper'

describe 'Items Find All Requests' do
  before(:each) do
    @merchant_1 = create(:merchant)
    @merchant_2 = create(:merchant)
    @item_1 = create(:item, merchant: @merchant_1)
    @item_2 = create(:item, merchant: @merchant_1, unit_price: 2.50)
    @item_3 = create(:item, merchant: @merchant_1, description: 'awesome')
    @item_4 = create(:item, merchant: @merchant_1, name: 'bobo')
    @item_5 = create(:item, merchant: @merchant_2)
    @item_6 = create(:item, merchant: @merchant_2, unit_price: 2.50)
    @item_7 = create(:item, merchant: @merchant_2, description: 'awesome')
    @item_8 = create(:item, merchant: @merchant_2, name: 'bobo')
  end

  it 'returns items with given merchant id' do
    get "/api/v1/items/find_all?merchant_id=#{@item_3.merchant.id}"

    parsed_items = JSON.parse(response.body)

    expect(response).to be_successful
    expect(parsed_items["data"].count).to eq(4)
    expect(parsed_items["data"].first["attributes"]["name"]).to eq(@item_1.name)
    expect(parsed_items["data"].second["attributes"]["name"]).to eq(@item_2.name)
    expect(parsed_items["data"].third["attributes"]["name"]).to eq(@item_3.name)
    expect(parsed_items["data"].fourth["attributes"]["name"]).to eq(@item_4.name)
  end

  it 'returns items with given unit price' do
    get "/api/v1/items/find_all?unit_price=#{@item_6.unit_price}"

    parsed_items = JSON.parse(response.body)

    expect(response).to be_successful
    expect(parsed_items["data"].count).to eq(2)
    expect(parsed_items["data"].first["attributes"]["id"]).to eq(@item_2.id)
    expect(parsed_items["data"].second["attributes"]["id"]).to eq(@item_6.id)
  end

  it 'returns items with given description' do
    get "/api/v1/items/find_all?description=#{@item_3.description}"

    parsed_items = JSON.parse(response.body)

    expect(response).to be_successful
    expect(parsed_items["data"].count).to eq(2)
    expect(parsed_items["data"].first["attributes"]["id"]).to eq(@item_3.id)
    expect(parsed_items["data"].second["attributes"]["id"]).to eq(@item_7.id)
  end

  it 'returns items with given partial description' do
    desc = @item_7.description
    partial_desc = desc[0..-3].downcase
    get "/api/v1/items/find_all?description=#{partial_desc}"

    parsed_items = JSON.parse(response.body)


    expect(response).to be_successful
    expect(parsed_items["data"].count).to eq(2)
    expect(parsed_items["data"].first["attributes"]["id"]).to eq(@item_3.id)
    expect(parsed_items["data"].second["attributes"]["id"]).to eq(@item_7.id)
  end

  it 'returns items with given name' do
    get "/api/v1/items/find_all?name=#{@item_4.name}"

    parsed_items = JSON.parse(response.body)

    expect(response).to be_successful
    expect(parsed_items["data"].count).to eq(2)
    expect(parsed_items["data"].first["attributes"]["id"]).to eq(@item_4.id)
    expect(parsed_items["data"].second["attributes"]["id"]).to eq(@item_8.id)
  end

  it 'returns items with given created timestamp' do
    item1 = create(:item, merchant: @merchant_1, created_at: "2020-03-21 01:00:00 UTC", updated_at: "2020-03-21 01:17:08 UTC")
    item2 = create(:item, merchant: @merchant_2, created_at: "2020-03-21 01:00:00 UTC", updated_at: "2020-03-21 01:17:08 UTC")
    item3 = create(:item, merchant: @merchant_1, created_at: "2020-03-21 01:00:00 UTC", updated_at: "2020-03-21 01:17:08 UTC")

    get "/api/v1/items/find_all?created_at=#{item3.created_at}"

    parsed_items = JSON.parse(response.body)

    expect(response).to be_successful
    expect(parsed_items["data"].count).to eq(3)
    expect(parsed_items["data"].first["attributes"]["id"]).to eq(item1.id)
    expect(parsed_items["data"].second["attributes"]["id"]).to eq(item2.id)
    expect(parsed_items["data"].third["attributes"]["id"]).to eq(item3.id)
  end

  it 'returns items with given updated timestamp' do
    item1 = create(:item, merchant: @merchant_1, created_at: "2020-03-21 01:00:00 UTC", updated_at: "2020-03-21 01:17:08 UTC")
    item2 = create(:item, merchant: @merchant_2, created_at: "2020-03-21 01:00:00 UTC", updated_at: "2020-03-21 01:17:08 UTC")
    item3 = create(:item, merchant: @merchant_1, created_at: "2020-03-21 01:00:00 UTC", updated_at: "2020-03-21 01:17:08 UTC")

    get "/api/v1/items/find_all?updated_at=#{item2.updated_at}"

    parsed_items = JSON.parse(response.body)

    expect(response).to be_successful
    expect(parsed_items["data"].count).to eq(3)
    expect(parsed_items["data"].first["attributes"]["id"]).to eq(item1.id)
    expect(parsed_items["data"].second["attributes"]["id"]).to eq(item2.id)
    expect(parsed_items["data"].third["attributes"]["id"]).to eq(item3.id)
  end

  it "returns items when given multiple attributes with accurate values" do
    item1 = create(:item, merchant: @merchant_1, name: "Car", created_at: "2020-03-21 01:00:00 UTC", updated_at: "2020-03-21 01:17:08 UTC")
    item2 = create(:item, merchant: @merchant_2, name: "Bike", created_at: "2020-03-21 01:00:00 UTC", updated_at: "2020-03-21 01:17:08 UTC")
    item3 = create(:item, merchant: @merchant_1, name: "Tire", created_at: "2020-03-21 01:00:00 UTC", updated_at: "2020-03-21 01:17:08 UTC")

    get "/api/v1/items/find_all?updated_at=#{item2.updated_at}&created_at=#{item3.created_at}"

    parsed_items = JSON.parse(response.body)

    expect(response).to be_successful
    expect(parsed_items["data"].count).to eq(3)
    expect(parsed_items["data"].first["attributes"]["id"]).to eq(item1.id)
    expect(parsed_items["data"].second["attributes"]["id"]).to eq(item2.id)
    expect(parsed_items["data"].third["attributes"]["id"]).to eq(item3.id)
  end

  it "returns items when given multiple attributes with partial values" do
    item1 = create(:item, merchant: @merchant_1, name: "Car", description: "NIghtly use", created_at: "2020-03-21 01:00:00 UTC", updated_at: "2020-03-21 01:17:08 UTC")
    item2 = create(:item, merchant: @merchant_2, name: "Car", description: "NigHTtime use", created_at: "2020-03-21 01:00:00 UTC", updated_at: "2020-03-21 01:17:08 UTC")
    item3 = create(:item, merchant: @merchant_1, name: "Tire", description: "interesting", created_at: "2020-03-21 01:00:00 UTC", updated_at: "2020-03-21 01:17:08 UTC")

    get "/api/v1/items/find_all?name=car&description=nightly"

    parsed_items = JSON.parse(response.body)

    expect(response).to be_successful
    expect(parsed_items["data"].count).to eq(2)
    expect(parsed_items["data"].first["attributes"]["id"]).to eq(item1.id)
    expect(parsed_items["data"].second["attributes"]["id"]).to eq(item2.id)
  end

end

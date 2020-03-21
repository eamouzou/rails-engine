require 'rails_helper'

describe 'Items Find Requests' do
  before(:each) do
    @merchant_1 = create(:merchant)
    @merchant_2 = create(:merchant)
    @item_1 = create(:item, merchant: @merchant_1)
    @item_2 = create(:item, merchant: @merchant_1)
    @item_3 = create(:item, merchant: @merchant_1)
    @item_4 = create(:item, merchant: @merchant_1)
    @item_5 = create(:item, merchant: @merchant_2)
    @item_6 = create(:item, merchant: @merchant_2)
    @item_7 = create(:item, merchant: @merchant_2)
    @item_8 = create(:item, merchant: @merchant_2)
  end

  it 'returns item with given id' do
    get "/api/v1/items/find?id=#{@item_1.id}"

    parsed_item = JSON.parse(response.body)

    expect(response).to be_successful
    expect(parsed_item["data"]["attributes"]["id"]).to eq(@item_1.id)
    expect(parsed_item["data"]["attributes"]["name"]).to eq(@item_1.name)
  end

  it 'returns item with given merchant id' do
    get "/api/v1/items/find?merchant_id=#{@item_5.merchant.id}"

    parsed_item = JSON.parse(response.body)

    expect(response).to be_successful
    expect(parsed_item["data"]["attributes"]["id"]).to eq(@item_5.id)
    expect(parsed_item["data"]["attributes"]["name"]).to eq(@item_5.name)
  end

  it 'returns item with given unit price' do
    get "/api/v1/items/find?unit_price=#{@item_2.unit_price}"

    parsed_item = JSON.parse(response.body)

    expect(response).to be_successful
    expect(parsed_item["data"]["attributes"]["id"]).to eq(@item_2.id)
    expect(parsed_item["data"]["attributes"]["name"]).to eq(@item_2.name)
  end

  it 'returns item with given description' do
    get "/api/v1/items/find?description=#{@item_6.description}"

    parsed_item = JSON.parse(response.body)

    expect(response).to be_successful
    expect(parsed_item["data"]["attributes"]["id"]).to eq(@item_6.id)
    expect(parsed_item["data"]["attributes"]["name"]).to eq(@item_6.name)
  end

  it 'returns item with given name' do
    get "/api/v1/items/find?name=#{@item_3.name}"

    parsed_item = JSON.parse(response.body)

    expect(response).to be_successful
    expect(parsed_item["data"]["attributes"]["id"]).to eq(@item_3.id)
    expect(parsed_item["data"]["attributes"]["name"]).to eq(@item_3.name)
  end

  it 'returns item with given created timestamp' do
    item = create(:item, merchant: @merchant_1, created_at: "2020-03-21 01:00:00 UTC", updated_at: "2020-03-21 01:17:08 UTC")

    get "/api/v1/items/find?created_at=#{item.created_at}"


    parsed_item = JSON.parse(response.body)

    expect(response).to be_successful
    expect(parsed_item["data"]["attributes"]["id"]).to eq(item.id)
    expect(parsed_item["data"]["attributes"]["name"]).to eq(item.name)
  end

  it 'returns item with given updated timestamp' do
    item = create(:item, merchant: @merchant_1, created_at: "2020-03-21 01:00:00 UTC", updated_at: "2020-03-21 01:17:08 UTC")

    get "/api/v1/items/find?updated_at=#{item.updated_at}"

    parsed_item = JSON.parse(response.body)

    expect(response).to be_successful
    expect(parsed_item["data"]["attributes"]["id"]).to eq(item.id)
    expect(parsed_item["data"]["attributes"]["name"]).to eq(item.name)
  end

end

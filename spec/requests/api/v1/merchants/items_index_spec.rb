require 'rails_helper'

describe 'Items API' do
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
    @item_9 = create(:item, merchant: @merchant_2)

    @items_1 = [@item_1, @item_2, @item_3, @item_4]
    @items_2 = [@item_5, @item_6, @item_7, @item_8, @item_9]
  end

  it 'returns all items associated with a merchant' do
    get "/api/v1/merchants/#{@merchant_1.id}/items"

    items = JSON.parse(response.body)

    expect(response).to be_successful
    expect(items["data"].count).to eq(4)
    expect(items["data"].first["attributes"]["id"]).to eq(@items_1.first.id)
    expect(items["data"].first["attributes"]["name"]).to eq(@items_1.first.name)
    expect(items["data"].first["attributes"]["description"]).to eq(@items_1.first.description)
    expect(items["data"].first["attributes"]["unit_price"]).to eq(@items_1.first.unit_price)
    expect(items["data"].first["attributes"]["merchant_id"]).to eq(@items_1.first.merchant_id)
  end

  it 'returns all items associated with a different merchant' do
    get "/api/v1/merchants/#{@merchant_2.id}/items"

    items = JSON.parse(response.body)

    expect(response).to be_successful
    expect(items["data"].count).to eq(5)
    expect(items["data"].first["attributes"]["id"]).to eq(@items_2.first.id)
    expect(items["data"].first["attributes"]["name"]).to eq(@items_2.first.name)
    expect(items["data"].first["attributes"]["description"]).to eq(@items_2.first.description)
    expect(items["data"].first["attributes"]["unit_price"]).to eq(@items_2.first.unit_price)
    expect(items["data"].first["attributes"]["merchant_id"]).to eq(@items_2.first.merchant_id)
  end
end

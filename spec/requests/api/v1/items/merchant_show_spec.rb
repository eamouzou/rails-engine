require 'rails_helper'

describe 'Items API' do
  before(:each) do
    @merchant_1 = create(:merchant)
    @merchant_2 = create(:merchant)
    @item_1 = create(:item, merchant: @merchant_1)
    @item_2 = create(:item, merchant: @merchant_2)
  end

  it 'returns all items associated with a merchant' do
    get "/api/v1/items/#{@item_1.id}/merchant"

    merchant = JSON.parse(response.body)

    expect(response).to be_successful
    expect(merchant["data"]["attributes"]["id"]).to eq(@item_1.merchant.id)

  end

  it 'returns all items associated with a different merchant' do
    get "/api/v1/items/#{@item_2.id}/merchant"

    merchant = JSON.parse(response.body)

    expect(response).to be_successful
    expect(merchant["data"]["attributes"]["id"]).to eq(@item_2.merchant.id)
  end

end

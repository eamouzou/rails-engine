require 'rails_helper'

describe 'Merchants API' do
  it 'sends a list of merchants' do
    create_list(:merchant, 4)

    get '/api/v1/merchants'

    expect(response).to be_successful

    merchants = JSON.parse(response.body)

    expect(merchants['data'].count).to eq(4)
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

    expect(Merchant.count).to eq(1)

    delete "/api/v1/merchants/#{merchant.id}"
    parsed_merchant = JSON.parse(response.body)


    expect(response).to be_successful
    expect(Merchant.count).to eq(0)
    expect{Merchant.find(merchant.id)}.to raise_error(ActiveRecord::RecordNotFound)
    expect(parsed_merchant['data']['attributes']).to eq({"id" => id, "name" => name})
  end


end

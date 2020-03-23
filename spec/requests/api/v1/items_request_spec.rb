require 'rails_helper'

describe 'Items API' do
  it 'sends a list of items' do
    create_list(:item, 4)

    get '/api/v1/items'

    expect(response).to be_successful

    items = JSON.parse(response.body)

    expect(items['data'].count).to eq(4)
  end

  it 'can get an item by its id' do
    item = create(:item)
    id = item.id
    name = item.name

    get "/api/v1/items/#{id}"

    item = JSON.parse(response.body)

    expect(response).to be_successful
    expect(item['data']['id'].to_i).to eq(id)
    expect(item['data']['attributes']['name']).to eq(name)
  end

  it "can create a item" do
    merchant = create(:merchant)
    item_params = {name: "Bolingo", description: "Love City", unit_price: 5011.96, merchant_id: merchant.id}

    post "/api/v1/items", params: item_params

    item = Item.last
    id = item.id
    parsed_item = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful
    expect(item.name).to eq(item_params[:name])
    expect(parsed_item[:data][:attributes][:name]).to eq(item.name)
    expect(parsed_item[:data][:attributes][:description]).to eq(item.description)
    expect(parsed_item[:data][:attributes][:unit_price]).to eq(item.unit_price)
    expect(parsed_item[:data][:attributes][:merchant_id]).to eq(item.merchant_id)
  end

  it "can update" do
    item = create(:item)
    id = item.id
    previous_name = Item.last.name
    item_params = { name: "Toy"}

    put "/api/v1/items/#{id}", params: item_params
    item = Item.find_by(id: id)
    parsed_item = JSON.parse(response.body)


    expect(response).to be_successful
    expect(item.name).to_not eq(previous_name)
    expect(item.name).to eq("Toy")
    expect(parsed_item['data']['attributes']).to eq({"description"=>item.description, "id"=>id, "merchant_id"=>item.merchant_id, "name"=>"Toy", "unit_price"=>item.unit_price})
  end

  it "can destroy a item" do
    item = create(:item)
    id = item.id
    name = item.name

    expect(Item.count).to eq(1)

    delete "/api/v1/items/#{item.id}"
    parsed_item = JSON.parse(response.body)


    expect(response).to be_successful
    expect(Item.count).to eq(0)
    expect{Item.find(item.id)}.to raise_error(ActiveRecord::RecordNotFound)
    expect(parsed_item['data']['id'].to_i).to eq(id)
    expect(parsed_item['data']['attributes']['name']).to eq(name)
  end

end

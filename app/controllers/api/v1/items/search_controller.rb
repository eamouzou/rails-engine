class Api::V1::Items::SearchController < ApplicationController

  def index
    params_length = request.query_parameters.keys.count
    render json: ItemSerializer.new(get_items) if params_length == 1
    render json: ItemSerializer.new(get_items_multiparams) if params_length > 1
  end

  def show
    params_length = request.query_parameters.keys.count
    render json: ItemSerializer.new(get_items.first) if params_length == 1
    render json: ItemSerializer.new(get_items_multiparams.first) if params_length > 1
  end


  private

  def parameters
    params.permit(:name, :description, :id, :created_at,
      :updated_at, :merchant_id, :unit_price)
  end

  def attribute
    parameters.keys.first
  end

  def value
    parameters.values.first
  end

  def get_items
    return find_by_description(attribute, value) if attribute == "description"
    return find_by_name(attribute, value) if attribute == "name"
    return Item.where(request.query_parameters) if !["description", "name"].include?(attribute)
  end

  def find_by_description(attribute, value)
    items = Item.arel_table
    Item.where(items[:description].matches("%#{value}%"))
  end

  def find_by_name(attribute, value)
    items = Item.arel_table
    Item.where(items[:name].matches("%#{value}%"))
  end

  def get_items_multiparams
    return Item.where(request.query_parameters) if include_name_or_description? == false
    return get_active_record_matches if include_name_or_description? == true
  end

  def include_name_or_description?
    request.query_parameters.keys.include?("name") || request.query_parameters.keys.include?("description")
  end

  def include_name_and_description?
    request.query_parameters.keys.include?("name") && request.query_parameters.keys.include?("description")
  end

  def get_active_record_matches
    all_matches = get_description_matches | get_name_matches if include_name_and_description? == true
    all_matches = get_corresponding_item_matches if include_name_and_description? == false
    Item.where(id: all_matches.map(&:id)).order(:created_at)
  end

  def get_corresponding_item_matches
    get_description_matches | get_params_matches if parameters.include?("description")
    get_name_matches | get_params_matches if parameters.include?("name")
  end

  def get_name_matches
    items = Item.arel_table
    params = request.query_parameters
    Item.where(items[:name].matches("%#{params["name"]}%"))
  end

  def get_description_matches
    items = Item.arel_table
    params = request.query_parameters
    Item.where(items[:description].matches("%#{params["description"]}%"))
  end

  def get_params_matches
    request.query_parameters.delete("name")
    request.query_parameters.delete("description")
    params_matches = Merchant.where(request.query_parameters)
  end

end

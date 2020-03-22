class Api::V1::Items::SearchController < ApplicationController

  def index
    params_length = request.query_parameters.keys.count
    render json: ItemSerializer.new(get_all_items) if params_length == 1
    render json: ItemSerializer.new(Item.where(request.query_parameters)) if params_length > 1
  end

  def show
    params_length = request.query_parameters.keys.count
    render json: ItemSerializer.new(get_one_item) if params_length == 1
    render json: ItemSerializer.new(Item.where(request.query_parameters).first) if params_length > 1
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

  def get_one_item
    return find_one_by_description(attribute, value) if attribute == "description"
    return find_one_by_name(attribute, value) if attribute == "name"
    return Item.find_by(request.query_parameters) if !["description", "name"].include?(attribute)
  end

  def find_one_by_description(attribute, value)
    items = Item.arel_table
    item = Item.where(items[:description].matches("%#{value}%"))
    item.first
  end

  def find_one_by_name(attribute, value)
    items = Item.arel_table
    item = Item.where(items[:name].matches("%#{value}%"))
    item.first
  end

  def get_all_items
    return find_all_by_description(attribute, value) if attribute == "description"
    return find_all_by_name(attribute, value) if attribute == "name"
    return Item.where(request.query_parameters) if !["description", "name"].include?(attribute)
  end

  def find_all_by_description(attribute, value)
    items = Item.arel_table
    Item.where(items[:description].matches("%#{value}%"))
  end

  def find_all_by_name(attribute, value)
    items = Item.arel_table
    Item.where(items[:name].matches("%#{value}%"))
  end

end

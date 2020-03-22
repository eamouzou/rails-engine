class Api::V1::Merchants::SearchController < ApplicationController

  def index
    params_length = request.query_parameters.keys.count
    render json: MerchantSerializer.new(get_merchants) if params_length == 1
    render json: MerchantSerializer.new(get_merchants_multiparams) if params_length > 1
  end

  def show
    params_length = request.query_parameters.keys.count
    render json: MerchantSerializer.new(get_merchant) if params_length == 1
    render json: MerchantSerializer.new(get_merchants_multiparams.first) if params_length > 1
  end


  private

  def parameters
    params.permit(:name, :created_at, :updated_at)
  end

  def attribute
    parameters.keys.first
  end

  def value
    parameters.values.first
  end

  def get_merchant
    return find_one_by_name(attribute, value) if attribute == "name"
    return Merchant.find_by(request.query_parameters) if attribute != "name"
  end

  def find_one_by_name(attribute, value)
    merchants = Merchant.arel_table
    merchant = Merchant.where(merchants[:name].matches("%#{value}%"))
    merchant.first
  end

  def get_merchants
    return find_all_by_name(attribute, value) if attribute == "name"
    return Merchant.where(request.query_parameters) if attribute != "name"
  end

  def find_all_by_name(attribute, value)
    merchants = Merchant.arel_table
    Merchant.where(merchants[:name].matches("%#{value}%"))
  end

  def get_merchants_multiparams
    Merchant.where(request.query_parameters) if include_name? == false
    get_active_record_matches if include_name? == true
  end

  def include_name?
    request.query_parameters.keys.include?("name")
  end

  def get_name_matches
    merchants = Merchant.arel_table
    params = request.query_parameters
    Merchant.where(merchants[:name].matches("%#{params["name"]}%"))
  end

  def get_params_matches
    request.query_parameters.delete("name")
    params_matches = Merchant.where(request.query_parameters)
  end

  def get_active_record_matches
    all_matches = get_name_matches | get_params_matches
    Merchant.where(id: all_matches.map(&:id)).order(:created_at)
  end

end

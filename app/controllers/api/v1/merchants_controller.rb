# app/controllers/api/v1/merchants_controller.rb

class Api::V1::MerchantsController < ApplicationController

  def index
    render json: MerchantSerializer.new(Merchant.all)
  end

  def show
    render json: MerchantSerializer.new(merchant_selection)
  end

  def create
    render json: MerchantSerializer.new(Merchant.create(merchant_params))
  end

  def update
    render json: MerchantSerializer.new(Merchant.update(params[:id], merchant_params))
  end

  def destroy
    render json: MerchantSerializer.new(Merchant.find(params[:id]))
    Merchant.delete(params[:id])
  end

  private

  def merchant_params
    params.require(:merchant).permit(:name)
  end

  def merchant_selection
    return Item.find(params[:item_id]).merchant if params[:id] == nil
    return Merchant.find(params[:id]) if params[:id]
  end


end

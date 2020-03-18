# app/controllers/api/v1/merchants_controller.rb

class Api::V1::MerchantsController < ApplicationController

  def index
    render json: MerchantSerializer.new(Merchant.all)
  end

  def show
    render json: MerchantSerializer.new(Merchant.find(params[:id]))
  end

  def create
    render json: MerchantSerializer.new(Merchant.create(params[:name]))
  end

  def update
    render json: MerchantSerializer.new(Merchant.update(params[:id], params[:name]))
  end

  def destroy
    Merchant.delete(params[:id])
  end


end

class Api::V1::Merchants::RevenuesController < ApplicationController
  def index
    merchants = Merchant.most_revenue(params[:quantity])
    render json: MerchantSerializer.new(merchants)
  end

  def show
    update_merchant(params[:merchant_id])
    render json: RevenueSerializer.new(Merchant.find(params[:merchant_id]))
  end

  private

  def update_merchant(id)
    merchant = Merchant.where(id: id)
    merchant.update(revenue: get_revenue(merchant))
  end

  def get_revenue(merchant)
    Merchant.revenue(merchant)
  end
end

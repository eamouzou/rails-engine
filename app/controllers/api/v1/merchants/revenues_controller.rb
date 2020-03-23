class Api::V1::Merchants::RevenuesController < ApplicationController
  def index
    merchants = Merchant.most_revenue(params[:quantity])
    render json: MerchantSerializer.new(merchants)
  end

  def show
    revenue = Merchant.revenue_by_dates(params[:start], params[:end])
    render json: RevenueSerializer.new(revenue)
  end
end

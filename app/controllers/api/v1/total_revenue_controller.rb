class Api::V1::TotalRevenueController < ApplicationController
  def show
    new_merchant = Merchant.create(name: 'Total Revenue', revenue: get_revenue)
    render json: RevenueSerializer.new(new_merchant)
  end

  private

  def get_revenue
    Merchant.revenue_by_dates(params[:start], params[:end])
  end
end

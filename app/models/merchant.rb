class Merchant < ApplicationRecord
  has_many :items, dependent: :destroy
  has_many :invoices, dependent: :destroy
  has_many :invoice_items, through: :invoices
  has_many :transactions, through: :invoices

  def self.most_revenue(quantity)
    quantity = quantity.to_i
    joins(invoices: [:invoice_items, :transactions])
    .where(transactions: {result: "success"})
    .select('merchants.*, sum(invoice_items.unit_price*invoice_items.quantity) as revenue')
    .group(:id)
    .order(revenue: :desc)
    .limit(quantity)
  end

end

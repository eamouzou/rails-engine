class Merchant < ApplicationRecord
  has_many :items, dependent: :destroy
  has_many :invoices, dependent: :destroy
  has_many :invoice_items, through: :invoices
  has_many :transactions, through: :invoices

  def self.most_revenue(quantity)
    quantity = quantity.to_i
    joins(invoices: [:invoice_items, :transactions])
    .select('merchants.*, sum(invoice_items.unit_price * invoice_items.quantity) as revenue')
    .group(:id)
    .where(transactions: {result: "success"})
    .order(revenue: :desc)
    .limit(quantity)
  end

  def self.most_items(quantity)
    quantity = quantity.to_i
    joins(invoices: [:invoice_items, :transactions])
    .select('merchants.*, sum(invoice_items.quantity) as total_amount')
    .group(:id)
    .where(transactions: {result: "success"})
    .order(total_amount: :desc)
    .limit(quantity)
  end

  def self.revenue_by_dates(start, finish)
    start = start + " 01:00:00"
    finish = finish + " 01:00:00"
    joins(invoices: [:invoice_items, :transactions])
    .where(transactions: {result: :success})
    .where("invoice_items.created_at >= '#{start}' AND invoice_items.created_at <= '#{finish}'")
    .sum('unit_price * quantity')
  end

  def self.revenue(merchant)
    merchant.joins(invoices: [:invoice_items, :transactions])
    .where(transactions: {result: :success})
    .sum('unit_price * quantity')
  end

end

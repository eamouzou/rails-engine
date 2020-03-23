require 'csv'

task import_csv_files: :environment do
  ActiveRecord::Base.connection.tables.each do |t|
    ActiveRecord::Base.connection.reset_pk_sequence!(t)
  end
  puts "Primary keys reset"
end

task import_csv_files: :environment do
  Merchant.destroy_all
  counter = 0
  CSV.foreach("db/data/merchants.csv", headers: true, header_converters: :symbol, converters: :all, header_converters: :symbol, converters: :all) do |row|
    merchant = Merchant.create(row.to_hash)
    counter += 1 if merchant.persisted?
  end
  puts "Imported #{counter} merchants."
end

task import_csv_files: :environment do
  Customer.destroy_all
  counter = 0
  CSV.foreach("db/data/customers.csv", headers: true, header_converters: :symbol, converters: :all) do |row|
    customer = Customer.create(row.to_hash)
    counter += 1 if customer.persisted?
  end
  puts "Imported #{counter} customers."
end

task import_csv_files: :environment do
  Item.destroy_all
  counter = 0
  CSV.foreach("db/data/items.csv", headers: true, header_converters: :symbol, converters: :all) do |row|
    item_hash = row.to_h
    item_hash["unit_price"] = (item_hash["unit_price"].to_f / 100).round(2)
    item = Item.create(item_hash)
    counter += 1 if item.persisted?
  end
  puts "Imported #{counter} items."
end

task import_csv_files: :environment do
  Invoice.destroy_all
  counter = 0
  CSV.foreach("db/data/invoices.csv", headers: true, header_converters: :symbol, converters: :all) do |row|
    invoice = Invoice.create(row.to_hash)
    counter += 1 if invoice.persisted?
  end
  puts "Imported #{counter} invoices."
end

task import_csv_files: :environment do
  Transaction.destroy_all
  counter = 0
  CSV.foreach("db/data/transactions.csv", headers: true, header_converters: :symbol, converters: :all) do |row|
    transaction = Transaction.create(row.to_hash)
    counter += 1 if transaction.persisted?
  end
  puts "Imported #{counter} transactions."
end

task import_csv_files: :environment do
  InvoiceItem.destroy_all
  counter = 0
  CSV.foreach("db/data/invoice_items.csv", headers: true, header_converters: :symbol, converters: :all) do |row|
    invoice_item = InvoiceItem.create(row.to_hash)
    counter += 1 if invoice_item.persisted?
  end
  puts "Imported #{counter} invoice items."
end

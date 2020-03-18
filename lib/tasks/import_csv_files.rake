require 'csv'

task import_csv_files: :environment do
  Merchant.destroy_all
  counter = 0
  CSV.foreach("db/data/merchants.csv", headers: true) do |row|
    merchant = Merchant.create(row.to_hash)
    counter += 1 if merchant.persisted?
  end
  puts "Imported #{counter} merchants."
end

task import_csv_files: :environment do
  Customer.destroy_all
  counter = 0
  CSV.foreach("db/data/customers.csv", headers: true) do |row|
    customer = Customer.create(row.to_hash)
    counter += 1 if customer.persisted?
  end
  puts "Imported #{counter} customers."
end

task import_csv_files: :environment do
  Item.destroy_all
  counter = 0
  CSV.foreach("db/data/items.csv", headers: true) do |row|
    item = Item.create(row.to_hash)
    counter += 1 if item.persisted?
  end
  puts "Imported #{counter} items."
end

task import_csv_files: :environment do
  Invoice.destroy_all
  counter = 0
  CSV.foreach("db/data/invoices.csv", headers: true) do |row|
    invoice = Invoice.create(row.to_hash)
    counter += 1 if invoice.persisted?
  end
  puts "Imported #{counter} invoices."
end

task import_csv_files: :environment do
  Transaction.destroy_all
  counter = 0
  CSV.foreach("db/data/transactions.csv", headers: true) do |row|
    transaction = Transaction.create(row.to_hash)
    counter += 1 if transaction.persisted?
  end
  puts "Imported #{counter} transactions."
end

task import_csv_files: :environment do
  InvoiceItem.destroy_all
  counter = 0
  CSV.foreach("db/data/invoice_items.csv", headers: true) do |row|
    invoice_item = InvoiceItem.create(row.to_hash)
    counter += 1 if invoice_item.persisted?
  end
  puts "Imported #{counter} invoice items."
end

# frozen_string_literal: true

class Item < ApplicationRecord
  belongs_to :tax

  def self.tax_calculation
    items = Item.includes(:tax).all
    total_price_including_tax = []
    total_sales_tax = []
    total_import_tax = []
    items_price_with_tax = []
    items.each do |item|
      sales_tax = (((item.shelf_price * item.tax.rate) / 100) * 20).round / 20
      price_with_tax = item.quantity * (item.shelf_price + sales_tax)
      if item.imported?
        imported_sales_tax = (((price_with_tax * 5) / 100) * 20).round / 20
        price_with_tax += imported_sales_tax
      end
      total_price_including_tax.push(price_with_tax)
      total_sales_tax.push(sales_tax)
      total_import_tax.push(imported_sales_tax)
      items_price_with_tax.push(
        {
          quantity: item.quantity,
          description: item.description,
          category: item.tax.name,
          price: item.shelf_price,
          sales_tax_rate: item.tax.rate,
          sales_tax: sales_tax,
          imported_sales_tax_rate: item.imported? ? 5 : 0,
          imported_sales_tax: imported_sales_tax,
          price_with_tax: price_with_tax
        })
    end
    {
      items_price_with_tax: items_price_with_tax,
      price_including_tax: total_price_including_tax.sum,
      total_sales_tax: total_sales_tax.sum,
      total_import_tax: total_import_tax.compact.sum
    }
  end
end

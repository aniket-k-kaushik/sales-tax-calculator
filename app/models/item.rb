# frozen_string_literal: true

class Item < ApplicationRecord
  belongs_to :tax

  validates :quantity, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :description, presence: true
  validates :shelf_price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :tax_id, presence: true

  def self.tax_calculation(convert_to)
    convert_to ||= "EUR"
    currenty_exchange_rate = currency_conversion(convert_to)["result"]
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
          price: (item.shelf_price * currenty_exchange_rate).round(2),
          sales_tax_rate: item.tax.rate,
          sales_tax: (sales_tax * currenty_exchange_rate).round(2),
          imported_sales_tax_rate: item.imported? ? 5 : 0,
          imported_sales_tax: ((imported_sales_tax * currenty_exchange_rate).round(2) if !imported_sales_tax.nil?) || 0,
          price_with_tax: (price_with_tax * currenty_exchange_rate).round(2)
        })
    end
    {
      currency_symbol: convert_to,
      items_price_with_tax: items_price_with_tax,
      price_including_tax: (total_price_including_tax.sum * currenty_exchange_rate).round(2),
      total_sales_tax: (total_sales_tax.sum * currenty_exchange_rate).round(2),
      total_import_tax: (total_import_tax.compact.sum * currenty_exchange_rate).round(2)
    }
  end

  def self.currency_conversion(convert_to)
    if convert_to != "EUR"
      require "uri"
      require "net/http"
      url = URI("https://api.apilayer.com/fixer/convert?to=#{convert_to}&from=EUR&amount=1")
      https = Net::HTTP.new(url.host, url.port)
      https.use_ssl = true
      request = Net::HTTP::Get.new(url)
      request["apikey"] = "8TMaJEr0wJukhJlJ0o7HTeaw2Vqv3iBP"
      response = https.request(request)
      JSON.parse(response.read_body)
    else
      { "result" => 1 }
    end
  end
end

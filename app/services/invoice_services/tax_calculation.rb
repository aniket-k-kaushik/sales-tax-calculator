# frozen_string_literal: true

module InvoiceServices
  class TaxCalculation
    include InvoiceServices::CurrencyConversion

    def initialize(invoice)
      @invoice = invoice
    end

    attr_accessor :invoice

    def tax_calculation(convert_to)
      convert_to ||= "EUR"
      currenty_exchange_rate = currency_conversion(convert_to)["result"]
      items = invoice.items.includes(:category)
      total_price_including_tax = []
      total_sales_tax = []
      total_import_tax = []
      items_price_with_tax = []
      items.each do |item|
        sales_tax = (((item.shelf_price * item.category.rate) / 100) * 20).round / 20
        price_with_tax = item.quantity * (item.shelf_price + sales_tax)
        imported_sales_tax = ((((price_with_tax * 5) / 100) * 20).round / 20 if item.imported?) || 0
        price_with_tax += imported_sales_tax
        total_price_including_tax.push(price_with_tax)
        total_sales_tax.push(sales_tax)
        total_import_tax.push(imported_sales_tax)
        items_price_with_tax.push(
          {
            quantity: item.quantity, description: item.description, category: item.category.name,
            price: (item.shelf_price * currenty_exchange_rate).round(2),
            sales_tax_rate: item.category.rate, sales_tax: (sales_tax * currenty_exchange_rate).round(2),
            imported_sales_tax_rate: item.imported? ? 5 : 0,
            imported_sales_tax: (imported_sales_tax * currenty_exchange_rate).round(2),
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
  end
end

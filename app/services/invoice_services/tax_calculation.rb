# frozen_string_literal: true

module InvoiceServices
  class TaxCalculation
    include InvoiceServices::CurrencyConversion

    attr_accessor :invoice, :items, :price_including_tax_array,
      :sales_tax_array, :import_tax_array, :items_price_with_tax_array

    def initialize(invoice)
      @invoice = invoice
      @items = invoice.items.includes(:category)
      @sales_tax_array = []
      @import_tax_array = []
      @items_price_with_tax_array = []
      @price_including_tax_array = []
    end

    def process(convert_to = "EUR")
      currenty_exchange_rate = currency_conversion(convert_to)["result"]
      items.each do |item|
        calculate_sales_tax(item)
        calculate_price_with_sales_tax(item)
        calculate_imported_sales_tax(item)
        calculate_price_with_import_tax(item)
        push_calculated_price_and_tax(item, currenty_exchange_rate)
      end
      final_calculated_price_with_tax_hash(currenty_exchange_rate, convert_to)
    end

    private

      def calculate_sales_tax(item)
        @sales_tax = (((item.shelf_price * item.category.rate) / 100) * 20).round / 20
      end

      def calculate_price_with_sales_tax(item)
        @price_with_tax = item.quantity * (item.shelf_price + @sales_tax)
      end

      def calculate_imported_sales_tax(item)
        @import_tax = ((((@price_with_tax * 5) / 100) * 20).round / 20 if item.imported?) || 0
      end

      def calculate_price_with_import_tax(item)
        @price_with_tax += @import_tax
      end

      def push_calculated_price_and_tax(item, currenty_exchange_rate)
        sales_tax_array.push(@sales_tax)
        import_tax_array.push(@import_tax)
        price_including_tax_array.push(@price_with_tax)
        items_price_with_tax_array.push(calculate_each_item_price_with_tax(item, currenty_exchange_rate))
      end

      def final_calculated_price_with_tax_hash(currenty_exchange_rate, convert_to)
        {
          currency_symbol: convert_to,
          items_price_with_tax: items_price_with_tax_array,
          price_including_tax: (price_including_tax_array.sum * currenty_exchange_rate).round(2),
          total_sales_tax: (sales_tax_array.sum * currenty_exchange_rate).round(2),
          total_import_tax: (import_tax_array.compact.sum * currenty_exchange_rate).round(2)
        }
      end

      def calculate_each_item_price_with_tax(item, currenty_exchange_rate)
        {
          quantity: item.quantity,
          description: item.description,
          category: item.category.name,
          price: (item.shelf_price * currenty_exchange_rate).round(2),
          sales_tax_rate: item.category.rate,
          sales_tax: (@sales_tax * currenty_exchange_rate).round(2),
          imported_sales_tax_rate: item.imported? ? 5 : 0,
          imported_sales_tax: (@import_tax * currenty_exchange_rate).round(2),
          price_with_tax: (@price_with_tax * currenty_exchange_rate).round(2)
        }
      end
  end
end

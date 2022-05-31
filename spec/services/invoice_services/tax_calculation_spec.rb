# frozen_string_literal: true

require "rails_helper"

RSpec.describe InvoiceServices::TaxCalculation, type: :model do
  describe "#process" do
    let(:category) { Category.create(name: "book", rate: 0) }
    let(:invoice) { Invoice.create(invoice_number: "Inovice-01") }
    let!(:item) { Item.create(
      quantity: 10,
      description: "Goldern Books",
      shelf_price: 100,
      imported: true,
      category_id: category.id,
      invoice_id: invoice.id) }
    let!(:convert_to) { "EUR" }
    it "calculats sales tax and import_tax" do
      result = {
        currency_symbol: convert_to,
        items_price_with_tax: [ quantity: 10,
                                description: "Goldern Books",
                                category: "book",
                                price: 100,
                                sales_tax_rate: 0,
                                sales_tax: 0,
                                imported_sales_tax_rate: 5,
                                imported_sales_tax: 50,
                                price_with_tax: 1050
        ],
        price_including_tax: 1050,
        total_sales_tax: 0,
        total_import_tax: 50
      }
      calculated_tax_response = InvoiceServices::TaxCalculation.new(invoice).process(convert_to)
      expect(calculated_tax_response).to eq(result)
    end
  end
end

# frozen_string_literal: true

require "rails_helper"

RSpec.describe Invoice, type: :model do
  context "validation test" do
    it "ensure invoice number is present" do
      invoice = Invoice.new().save
      expect(invoice).to eq(false)
    end
  end

  context "Association test" do
    it "ensure invoice has many items" do
      should respond_to(:items)
    end
  end
end

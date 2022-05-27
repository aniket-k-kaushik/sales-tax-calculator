# frozen_string_literal: true

class TaxsCalculatorController < ApplicationController
  def show
    @invoice = Invoice.find(params[:id])
    @items = InvoiceServices::TaxCalculation.new(@invoice).tax_calculation(params[:convert_to])
  rescue
    redirect_to taxs_calculator_path(@invoice, convert_to: "EUR")
  end
end

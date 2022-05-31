# frozen_string_literal: true

class TaxsCalculatorController < ApplicationController
  def show
    @invoice = Invoice.find(params[:id])
    @items = InvoiceServices::TaxCalculation.new(@invoice).process(params[:convert_to])
  rescue StandardError => e
    print e.backtrace
    redirect_to taxs_calculator_path(@invoice, convert_to: "EUR")
  end
end

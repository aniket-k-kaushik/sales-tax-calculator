# frozen_string_literal: true

class TaxsCalculatorController < ApplicationController
  def show
    @invoice = Invoice.find(params[:id])
    @items = @invoice.items.tax_calculation(params[:convert_to])
  end
end

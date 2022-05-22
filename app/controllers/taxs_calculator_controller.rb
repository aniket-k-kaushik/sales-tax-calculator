# frozen_string_literal: true

class TaxsCalculatorController < ApplicationController
  def index
    @items = Item.tax_calculation(params[:convert_to])
  end
end

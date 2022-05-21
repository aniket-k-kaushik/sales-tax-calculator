# frozen_string_literal: true

class TaxsCalculatorController < ApplicationController
  def index
    @items = Item.tax_calculation
  end
end

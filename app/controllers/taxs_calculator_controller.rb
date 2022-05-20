# frozen_string_literal: true

class TaxsCalculatorController < ApplicationController
  def index
    @items = Item.all
  end
end

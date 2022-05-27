# frozen_string_literal: true

class Item < ApplicationRecord
  belongs_to :category
  belongs_to :invoice

  validates :quantity, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :description, presence: true
  validates :shelf_price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :category_id, presence: true
end

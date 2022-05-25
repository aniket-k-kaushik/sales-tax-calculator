# frozen_string_literal: true

class Category < ApplicationRecord
  has_many :items
  scope :by_name, -> { order(:name) }

  validates :name, presence: true
  validates :rate, presence: true, numericality: { greater_than_or_equal_to: 0 }
end

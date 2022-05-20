# frozen_string_literal: true

class Tax < ApplicationRecord
  has_many :items
  scope :by_name, -> { order(:name) }
end

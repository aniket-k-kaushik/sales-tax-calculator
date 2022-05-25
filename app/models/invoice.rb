# frozen_string_literal: true

class Invoice < ApplicationRecord
  has_many :items, dependent: :destroy

  validates :invoice_number, presence: true
end

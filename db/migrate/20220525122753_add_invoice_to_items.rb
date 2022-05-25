# frozen_string_literal: true

class AddInvoiceToItems < ActiveRecord::Migration[7.0]
  def change
    add_reference :items, :invoice, null: false, foreign_key: true
  end
end

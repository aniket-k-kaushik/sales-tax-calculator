# frozen_string_literal: true

class CreateTaxes < ActiveRecord::Migration[7.0]
  def change
    create_table :taxes do |t|
      t.string :name
      t.integer :rate

      t.timestamps
    end
  end
end

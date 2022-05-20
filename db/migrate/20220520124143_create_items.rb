# frozen_string_literal: true

class CreateItems < ActiveRecord::Migration[7.0]
  def change
    create_table :items do |t|
      t.integer :quantity
      t.string :description
      t.integer :shelf_price
      t.boolean :imported
      t.references :tax, index: true, null: false, foreign_key: true

      t.timestamps
    end
  end
end

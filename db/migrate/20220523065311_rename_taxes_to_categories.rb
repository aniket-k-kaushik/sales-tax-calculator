# frozen_string_literal: true

class RenameTaxesToCategories < ActiveRecord::Migration[7.0]
  def change
    rename_table :taxes, :categories
  end
end

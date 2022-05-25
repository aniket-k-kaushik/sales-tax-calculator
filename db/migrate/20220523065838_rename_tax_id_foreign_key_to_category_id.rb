# frozen_string_literal: true

class RenameTaxIdForeignKeyToCategoryId < ActiveRecord::Migration[7.0]
  def change
    rename_column :items, :tax_id, :category_id
  end
end

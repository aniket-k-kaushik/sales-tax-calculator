# frozen_string_literal: true

class ItemsController < ApplicationController
  include ActionView::RecordIdentifier
  before_action :set_item, only: %i[ show edit update destroy ]
  before_action :set_select_collections, only: [:edit, :update, :new, :create]
  # GET /items
  def index
    @items = Item.includes(:tax).all
  end

  # GET /items/1
  def show
  end

  # GET /items/new
  def new
    @item = Item.new
  end

  # GET /items/1/edit
  def edit
    @taxes = Tax.all.by_name
  end

  # POST /items

  def create
    @item = Item.new(item_params)
    if @item.save
      flash.now[:notice] = "Item was successfully created."
      render turbo_stream: [
        turbo_stream.prepend("items", @item),
        turbo_stream.replace(
          "form_item",
          partial: "form",
          locals: { item: Item.new }
        ),
        turbo_stream.replace("notice", partial: "layouts/flash")
      ]
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /items/1

  def update
    if @item.update(item_params)
      flash.now[:notice] = "Item was successfully updated."
      render turbo_stream: [
        turbo_stream.replace(@item, @item),
        turbo_stream.replace("notice", partial: "layouts/flash")
      ]
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /items/1

  def destroy
    @item.destroy
    flash.now[:notice] = "Item was successfully destroyed."
    render turbo_stream: [
      turbo_stream.remove(@item),
      turbo_stream.replace("notice", partial: "layouts/flash")
    ]
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_item
      @item = Item.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def item_params
      params.require(:item).permit(:quantity, :description, :shelf_price, :imported, :tax_id)
    end

    def set_select_collections
      @taxes = Tax.all.by_name
    end
end

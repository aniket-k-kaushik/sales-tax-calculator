# frozen_string_literal: true

class CategoriesController < ApplicationController
  include ActionView::RecordIdentifier
  before_action :set_tax, only: %i[ show edit update destroy ]

  # GET /taxes
  def index
    @categories = Category.all
  end

  # GET /taxes/1
  def show
  end

  # GET /taxes/new
  def new
    @category = Category.new
  end

  # GET /taxes/1/edit
  def edit
  end

  # POST /taxes
  def create
    @category = Category.new(category_params)
    if @category.save
      flash.now[:notice] = "Category was successfully created."
      render turbo_stream: [
        turbo_stream.prepend("categories", @category),
        turbo_stream.replace(
          "form_category",
          partial: "form",
          locals: { category: Category.new }
        ),
        turbo_stream.replace("notice", partial: "layouts/flash")
      ]
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /taxes/1
  def update
    if @category.update(category_params)
      flash.now[:notice] = "Category was successfully updated."
      render turbo_stream: [
        turbo_stream.replace(@category, @category),
        turbo_stream.replace("notice", partial: "layouts/flash")
      ]
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /taxes/1
  def destroy
    @category.destroy
    flash.now[:notice] = "Category was successfully destroyed."
    render turbo_stream: [
      turbo_stream.remove(@category),
      turbo_stream.replace("notice", partial: "layouts/flash")
    ]
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_tax
      @category = Category.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def category_params
      params.require(:category).permit(:name, :rate)
    end
end

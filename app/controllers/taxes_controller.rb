# frozen_string_literal: true

class TaxesController < ApplicationController
  include ActionView::RecordIdentifier
  before_action :set_tax, only: %i[ show edit update destroy ]

  # GET /taxes or /taxes.json
  def index
    @taxes = Tax.all
  end

  # GET /taxes/1 or /taxes/1.json
  def show
  end

  # GET /taxes/new
  def new
    @tax = Tax.new
  end

  # GET /taxes/1/edit
  def edit
  end

  # POST /taxes or /taxes.json
  def create
    @tax = Tax.new(tax_params)
    if @tax.save
      flash.now[:notice] = "Tax was successfully created."
      render turbo_stream: [
        turbo_stream.prepend("taxes", @tax),
        turbo_stream.replace(
          "form_tax",
          partial: "form",
          locals: { tax: Tax.new }
        ),
        turbo_stream.replace("notice", partial: "layouts/flash")
      ]
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /taxes/1 or /taxes/1.json
  def update
    if @tax.update(tax_params)
      flash.now[:notice] = "Tax was successfully updated."
      render turbo_stream: [
        turbo_stream.replace(@tax, @tax),
        turbo_stream.replace("notice", partial: "layouts/flash")
      ]
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /taxes/1 or /taxes/1.json
  def destroy
    @tax.destroy
    flash.now[:notice] = "Tax was successfully destroyed."
    render turbo_stream: [
      turbo_stream.remove(@tax),
      turbo_stream.replace("notice", partial: "layouts/flash")
    ]
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_tax
      @tax = Tax.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def tax_params
      params.require(:tax).permit(:name, :rate)
    end
end

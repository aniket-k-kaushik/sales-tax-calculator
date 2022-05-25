# frozen_string_literal: true

class InvoicesController < ApplicationController
  include ActionView::RecordIdentifier
  before_action :set_invoice, only: %i[ show edit update destroy ]

  # GET /invoices or /invoices.json
  def index
    @invoices = Invoice.all
  end

  # GET /invoices/1 or /invoices/1.json
  def show
    @items = set_invoice.items
  end

  # GET /invoices/new
  def new
    @invoice = Invoice.new
  end

  # GET /invoices/1/edit
  def edit
  end

  # POST /invoices or /invoices.json
  def create
    @invoice = Invoice.new(invoice_params)
    if @invoice.save
      flash.now[:notice] = "Invoice was successfully created."
      render turbo_stream: [
        turbo_stream.prepend("invoices", @invoice),
        turbo_stream.replace(
          "form_invoice",
          partial: "form",
          locals: { invoice: Invoice.new }
        ),
        turbo_stream.replace("notice", partial: "layouts/flash")
      ]
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /invoices/1 or /invoices/1.json
  def update
    if @invoice.update(invoice_params)
      flash.now[:notice] = "Invoice was successfully updated."
      render turbo_stream: [
        turbo_stream.replace(@invoice, @invoice),
        turbo_stream.replace("notice", partial: "layouts/flash")
      ]
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /invoices/1 or /invoices/1.json
  def destroy
    @invoice.destroy
    flash.now[:notice] = "Invoice was successfully destroyed."
    render turbo_stream: [
      turbo_stream.remove(@invoice),
      turbo_stream.replace("notice", partial: "layouts/flash")
    ]
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_invoice
      @invoice = Invoice.includes(:items).find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def invoice_params
      params.require(:invoice).permit(:invoice_number)
    end
end

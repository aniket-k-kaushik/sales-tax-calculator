# frozen_string_literal: true

class TaxsCalculatorController < ApplicationController
  def show
    @invoice = Invoice.find(params[:id])
    @items = InvoiceServices::TaxCalculation.new(@invoice).process(params[:convert_to])
  rescue
    redirect_to taxs_calculator_path(@invoice, convert_to: "EUR")
  end

  def download
    @invoice = Invoice.find(params[:id])
    @items = InvoiceServices::TaxCalculation.new(@invoice).process(params[:convert_to])
    html_string = render_to_string({ template: "taxs_calculator/download", layout: "layouts/pdf" })
    grover = Grover.new(html_string, format: "A3", display_url: "http://127.0.0.1:3000")
    pdf = grover.to_pdf
    send_data(pdf, disposition: "inline", filename: "#{@invoice.invoice_number}", type: "application/pdf")
  end
end

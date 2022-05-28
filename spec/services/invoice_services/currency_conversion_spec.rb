# frozen_string_literal: true

require "rails_helper"

include InvoiceServices::CurrencyConversion

RSpec.describe InvoiceServices::CurrencyConversion, type: :model do
  describe "#currency_conversion" do
    # context "when conversion currency is INR" do
    #   let(:convert_to) { "INR" }
    #   it "converts EUR to INR" do
    #     # result = {"result"=>1}
    #     require "uri"
    #     require "net/http"
    #     url = URI("https://api.apilayer.com/fixer/convert?to=#{convert_to}&from=EUR&amount=1")
    #     https = Net::HTTP.new(url.host, url.port)
    #     https.use_ssl = true
    #     request = Net::HTTP::Get.new(url)
    #     request["apikey"] = Rails.application.credentials.fixer[:apikey]
    #     response = https.request(request)
    #     result = JSON.parse(response.read_body)
    #     currency_conversion_response = currency_conversion(convert_to)
    #     expect(currency_conversion_response).to eq(result)
    #   end
    # end
    #
    context "when conversion currency is EUR" do
      let(:convert_to) { "EUR" }
      it "EUR currency " do
        result = { "result" => 1 }
        currency_conversion_response = currency_conversion(convert_to)
        expect(currency_conversion_response).to eq(result)
      end
    end
  end
end

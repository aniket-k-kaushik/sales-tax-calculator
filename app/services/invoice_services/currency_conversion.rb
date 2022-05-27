# frozen_string_literal: true

module InvoiceServices
  module CurrencyConversion
    def currency_conversion(convert_to)
      if convert_to != "EUR"
        require "uri"
        require "net/http"
        url = URI("https://api.apilayer.com/fixer/convert?to=#{convert_to}&from=EUR&amount=1")
        https = Net::HTTP.new(url.host, url.port)
        https.use_ssl = true
        request = Net::HTTP::Get.new(url)
        request["apikey"] = Rails.application.credentials.fixer[:apikey]
        response = https.request(request)
        JSON.parse(response.read_body)
      else
        { "result" => 1 }
      end
    end
  end
end

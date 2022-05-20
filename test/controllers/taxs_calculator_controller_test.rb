# frozen_string_literal: true

require "test_helper"

class TaxsCalculatorControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get taxs_calculator_index_url
    assert_response :success
  end
end

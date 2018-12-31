module Lazada
  module API

    # No Lazada documentation describes the format of an error message
    # Using the following errror message as example
    # {"code"=>"501", "type"=>"ISP", "message"=>"E501: Update product failed", "detail"=>[{"field"=>"Product", "message"=>"Category is inactive"}], "request_id"=>"xxxxxxxxxxxxxx60"}
    class Response
      attr_reader :response
      attr_reader :request

      def initialize(response)
        @response = response
        @request = response.request
      end

      def request_id
        response&.dig "request_id"
      end

      def success?
        true
      end

      def code
        response.dig "code"
      end

      def error?
        response.dig("code") != "0"
      end

      # Used for authentication APIs only
      def error_message
        response.dig("message")
      end

      # {"code"=>"501", "type"=>"ISP", "message"=>"E501: Update product failed", "detail"=>[{"field"=>"Product", "message"=>"Category is inactive"}], "request_id"=>"xxxxxxxxxxxxxx60"}
      def error_details
        response.dig("detail").map { |d| "#{d.dig("field")}: #{d.dig("message")}" }.join(". ")
      end

      def [](idx)
        response[idx]
      end
    end
  end
end

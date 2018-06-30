module Lazada
  module API
    class Response
      attr_reader :response

      def initialize(response)
        @response = response
      end

      def request_id
        response&.dig 'request_id'
      end

      def success?
        true
      end

      def code
        response.dig 'code'
      end

      def error?
        response.dig('code') != "0"
      end

      def error_message
        response.dig('message')
      end

      def [](idx)
        response[idx]
      end
    end
  end
end

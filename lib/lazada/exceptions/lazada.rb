module Lazada
  class LazadaError < StandardError
    def initialize(message = nil)
      super message
    end
  end

  class APIError < LazadaError
    attr_reader :response
    attr_reader :request

    attr_reader :code
    attr_reader :message

    def initialize(message = nil, params = {})
      super message

      @response = params[:response]
      @request = params[:request]

      @code = params[:code]
      @message = params[:message]
    end
  end
end

require 'httparty'
require 'active_support/core_ext/hash'

require 'lazada/api/product'
require 'lazada/api/category'
require 'lazada/api/feed'
require 'lazada/api/image'
require 'lazada/api/order'
require 'lazada/api/response'
require 'lazada/api/brand'
require 'lazada/exceptions/lazada'

module Lazada
  class Client
    include HTTParty
    include Lazada::API::Product
    include Lazada::API::Category
    include Lazada::API::Feed
    include Lazada::API::Image
    include Lazada::API::Order
    include Lazada::API::Brand

    base_uri 'https://api.sellercenter.lazada.com.my'

    # Valid opts:
    # - tld: Top level domain to use (.com.my, .sg, .th...). Default: com.my
    # - debug: $stdout, Rails.logger. Log http requests
    def initialize(api_key, user_id, opts = {})
      @api_key = api_key
      @user_id = user_id
      @timezone = opts[:timezone] || 'UTC'
      @raise_exceptions = opts[:raise_exceptions] || true

      self.class.base_uri "https://api.sellercenter.lazada#{opts[:tld]}" if opts[:tld].present?
      self.class.debug_output opts[:debug] if opts[:debug].present?
    end

    protected

    def request_url(action, options = {})
      current_time_zone = @timezone
      timestamp = Time.now.in_time_zone(current_time_zone).iso8601

      parameters = {
        'Action' => action,
        'Filter' => options.delete('filter'),
        'Format' => 'JSON',
        'Timestamp' => timestamp,
        'UserID' => @user_id,
        'Version' => '1.0'
      }

      parameters = parameters.merge(options) if options.present?

      parameters = Hash[parameters.sort{ |a, b| a[0] <=> b[0] }]
      params     = parameters.to_query

      signature = OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha256'), @api_key, params)
      url = "/?#{params}&Signature=#{signature}"
    end

    def process_response_errors!(response)
      return unless @raise_exceptions

      parsed_response = Lazada::API::Response.new(response)

      if parsed_response.error?
        raise Lazada::APIError.new(
          "Lazada API Error: '#{parsed_response.error_message}'",
          http_code: response&.code,
          response: response&.inspect,
          error_type: parsed_response.error_type,
          error_code: parsed_response.error_code,
          error_message: parsed_response.error_message,
          error_detail: parsed_response.body_error_messages
        )
      end
    end
  end

end

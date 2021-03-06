require "httparty"

require "lazada/api/product"
require "lazada/api/category"
require "lazada/api/feed"
require "lazada/api/image"
require "lazada/api/order"
require "lazada/api/response"
require "lazada/api/brand"
require "lazada/api/auth"
require "lazada/exceptions/lazada"

module Lazada
  class Client
    include HTTParty
    include Lazada::API::Product
    include Lazada::API::Category
    include Lazada::API::Feed
    include Lazada::API::Image
    include Lazada::API::Order
    include Lazada::API::Brand
    include Lazada::API::Auth

    attr_accessor :access_token

    # Valid opts:
    # - tld: Top level domain to use (.com.my, .sg, .co.th...)
    # - debug: $stdout, Rails.logger. Log http requests
    # - redirect_url: for oauth code redirect
    # - access_token: oauth access token
    def initialize(app_key, app_secret, opts = {})
      @app_key = app_key
      @app_secret = app_secret
      @timezone = "UTC"
      @redirect_url = opts[:redirect_url]
      @raise_exceptions = opts[:raise_exceptions] || true
      @tld = opts[:tld]
      @access_token = opts[:access_token]
      @rails_logger = opts[:rails_logger] if opts[:rails_logger].is_a?("ActiveSupport::Logger".constantize)

      self.class.debug_output opts[:debug] unless opts[:debug].nil?
    end

    protected

    def request_url(path, options = {})
      is_auth = options[:is_auth] || false
      current_time_zone = @timezone
      # ISO does not seem to be supported any longer by Lazada
      # timestamp = Time.now.in_time_zone(current_time_zone).iso8601
      timestamp = (Time.now.to_f * 1000).to_i

      parameters = {
        "app_key" => @app_key,
        "format" => "json",
        "timestamp" => timestamp,
        "sign_method" => "sha256",
      }

      parameters.merge!({"access_token" => @access_token}) unless @access_token.nil?

      # Hash keys to String keys
      options.delete(:is_auth)
      options.keys.each { |key| options[key.to_s] = options.delete(key) }
      parameters = parameters.merge(options) if options.present?

      parameters = Hash[parameters.sort { |a, b| a[0] <=> b[0] }]
      sign_string = parameters.map { |k, v| "#{k}#{v}" }.join
      sign_string = path + sign_string
      signature = OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new("sha256"), @app_secret, sign_string).upcase

      params = parameters.to_query

      if is_auth
        "https://auth.lazada.com/rest#{path}?#{params}&sign=#{signature}"
      else
        "https://api.lazada#{@tld}/rest#{path}?#{params}&sign=#{signature}"
      end
    end

    def process_response(lazada_response)
      return unless @raise_exceptions

      if lazada_response.error?
        message = lazada_response.error_details,
        message = lazada_response.error_message if message.blank?

        raise Lazada::APIError.new(
          lazada_response.error_details,
          request: lazada_response,
          response: lazada_response.response,
          code: lazada_response.code,
          message: message,
        )
      end

      lazada_response
    rescue StandardError => error
      @rails_logger&.error "The response was #{lazada_response}"
      @rails_logger&.error error.backtrace
      raise error
    end
  end
end

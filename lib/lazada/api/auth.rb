require 'securerandom'

module Lazada
    module API
      module Auth

        def lazada_sign_in_url(opts = {})
          raise LazadaError.new 'Missing redirect_url parameter' if @redirect_url.nil? || @redirect_url.empty?
          raise LazadaError.new 'Missing app_key parameter' if @app_key.nil? || @app_key.empty?

          "https://auth.lazada.com/oauth/authorize?&response_type=code&redirect_uri=#{CGI.escape(@redirect_url)}&force_auth=true&client_id=#{@app_key}"
        end

        def create_access_token(auth_code)
          url = request_url('/auth/token/create', code: auth_code, is_auth: true)
          response = self.class.get(url)

          laz_res = Lazada::API::Response.new response
          process_auth_response laz_res
        end

        def refresh_token(refresh_token)
          url = request_url('/auth/token/refresh', refresh_token: refresh_token, is_auth: true)
          response = self.class.get(url)

          laz_res = Lazada::API::Response.new response
          process_auth_response laz_res
        end

        private

        def process_auth_response(lazada_response)
          if lazada_response.error?
            raise Lazada::APIError.new(
              lazada_response.error_message,
              error_code: lazada_response.code,
              request: lazada_response.request,
              response: lazada_response.response,
            )
          end

          {
            access_token: lazada_response['access_token'],
            expires_in: lazada_response['expires_in'],
            refresh_token: lazada_response['refresh_token'],
            refresh_expires_in: lazada_response['refresh_expires_in'],
            full_response: lazada_response.response.parsed_response,
          }
        end  
      end
    end
  end
  
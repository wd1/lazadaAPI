module Lazada
  module API
    module Brand
      def get_brands(options = {})
        options["offset"] = 0 unless options["offset"]

        url = request_url('/brands/get', options)
        response = self.class.get(url)

        process_response response

        Lazada::Response.new response
      end
    end
  end
end

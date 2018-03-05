module Lazada
  module API
    module Brand
      def get_brands(options = {})
        options["Offset"] = 0 unless options["Offset"]
        url = request_url('GetBrands', options)
        response = self.class.get(url)

        return response['SuccessResponse']['Body'] if response['SuccessResponse']
        response
      end
    end
  end
end

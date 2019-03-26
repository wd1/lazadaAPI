module Lazada
  module API
    module Order
      def get_orders(options = {})
        params = {}
        params["status"] = options[:status] if options[:status].present?
        params["created_after"] = options[:created_after].iso8601 if options[:created_after].present?
        params["limit"] = options[:limit] || 100
        params["offset"] = options[:offset] || 0
        params["sort_by"] = options[:sort_by] || "created_at"
        params["sort_direction"] = options[:sort_direction] || "DESC"

        url = request_url("/orders/get", params)
        response = self.class.get(url)

        lz_res = Lazada::API::Response.new response
        process_response lz_res
        lz_res
      end

      def get_order(id)
        url = request_url("/order/get", {"order_id" => id})
        response = self.class.get(url)

        lz_res = Lazada::API::Response.new response
        process_response lz_res
        lz_res
      end

      def get_order_items(id)
        url = request_url("/order/items/get", {"order_id" => id})
        response = self.class.get(url)

        lz_res = Lazada::API::Response.new response
        process_response lz_res
        lz_res
      end

      def get_multiple_order_items(ids_list)
        raise Lazada::LazadaError("IDs list must be an Array of integers or strings") unless ids_list.is_a?(Array)

        url = request_url("/orders/items/get", {"order_ids" => "[#{ids_list.join(",")}]"})
        response = self.class.get(url)

        lz_res = Lazada::API::Response.new response
        process_response lz_res
        lz_res
      end
    end
  end
end

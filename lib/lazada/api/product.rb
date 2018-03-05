module Lazada
  module API
    module Product
      def get_products(status = 'all')
        url = request_url('GetProducts', { 'filter' => status })
        response = self.class.get(url)

        process_response_errors! response

        response['SuccessResponse']['Body']['Products']
      end

      def create_product(params)
        url = request_url('CreateProduct')

        params = { 'Product' => product_params(params) }

        response = self.class.post(url, body: params.to_xml(root: 'Request', skip_types: true, dasherize: false))

        Lazada::API::Response.new(response)
      end

      def update_product(params)
        url = request_url('UpdateProduct')

        params = { 'Product' => product_params(params) }
        response = self.class.post(url, body: params.to_xml(root: 'Request', skip_types: true, dasherize: false))

        process_response_errors! response

        Lazada::API::Response.new(response)
      end

      def remove_product(seller_sku)
        url = request_url('RemoveProduct')

        params = {
          'Product' => {
            'Skus' => {
              'Sku' => {
                'SellerSku' => seller_sku
              }
            }
          }
        }

        response = self.class.post(url, body: params.to_xml(root: 'Request', skip_types: true))

        Lazada::API::Response.new(response)
      end

      def get_qc_status
        url = request_url('GetQcStatus')

        response = self.class.get(url)

        process_response_errors! response

        response['SuccessResponse']['Body']['Status']
      end

      private

      def product_params(object)
        params = {}
        params['PrimaryCategory'] = object[:primary_category]
        params['SPUId'] = ''
        params['AssociatedSku'] = ''
        params['Attributes'] = {
          'name' => object[:name],
          'name_ms' => object[:name_ms] || object[:name],
          'short_description' => object[:short_description],
          'brand' => object[:brand] || 'Unbranded',
          'warranty_type' => object[:warranty_type] || 'No Warranty',
          'model' => object[:model]
        }

        params['Skus'] = {}
        params['Skus']['Sku'] = {
          'SellerSku' => object[:seller_sku],
          'size' => object[:variation],
          'quantity' => object[:quantity],
          'price' => object[:price],
          'package_length' => object[:package_length],
          'package_height' => object[:package_height],
          'package_weight' => object[:package_weight],
          'package_width' => object[:package_width],
          'package_content' => object[:package_content],
          'tax_class' => object[:tax_class] || 'default',
          'status' => object[:status]
        }

        if object[:special_price].present?
          params['Skus']['Sku'].merge!({
            'special_price' => object[:special_price],
            'special_from_date' => object[:special_from_date],
            'special_to_date' => object[:special_to_date],
          })
        end

        params['Skus']['Sku']['color_family'] = object[:color_family] if object[:color_family].present?
        params['Skus']['Sku']['size'] = object[:size] if object[:size].present?
        params['Skus']['Sku']['flavor'] = object[:flavor] if object[:flavor].present?
        params['Skus']['Sku']['bedding_size_2'] = object[:bedding_size] if object[:bedding_size].present?

        params['Skus']['Sku']['Images'] = {}
        params['Skus']['Sku']['Images'].compare_by_identity

        if object[:images].present?
          object[:images].each do |image|
            url = migrate_image(image)

            params['Skus']['Sku']['Images']['Image'.dup] = url
          end
        end

        # maximum image: 8
        image_count = object[:images]&.size || 0
        (8 - image_count).times.each do |a|
          params['Skus']['Sku']['Images']['Image'.dup] = ''
        end

        params
      end
    end
  end
end

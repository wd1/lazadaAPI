module Lazada
  module API
    module Image
      def set_images(params)
        url = request_url('Image')

        params = { 'ProductImage' => params }
        response = self.class.post(url, body: params.to_xml(root: 'Request', skip_types: true))

        response
      end

      def migrate_image(image_url)
        xml = {
            'Image' => { 'Url' => image_url }
        }.to_xml(
          root: 'Request', 
          skip_types: true, 
          dasherize: false
        )

        params = { payload: xml }
        url = request_url('/image/migrate', params)
        response = self.class.post(url)

        lazada_response = Lazada::API::Response.new response
        process_response lazada_response
      end

      def migrate_images(image_url_list)
        # Allow duplicate keys in dict
        urls = {}.compare_by_identity
        image_url_list.each do |image_url| 
          urls.merge! String.new('Url') => image_url
        end

        xml = { 
            'Images' => urls
          }.to_xml(
            root: 'Request',
            skip_types: true,
            dasherize: false
          )
          
        params = { payload: xml }
        url = request_url('/images/migrate', params)
        response = self.class.post(url)

        lazada_response = Lazada::API::Response.new response
        process_response lazada_response
      end

    end
  end
end

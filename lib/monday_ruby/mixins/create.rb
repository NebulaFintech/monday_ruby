# frozen_string_literal: true

module MondayRuby
  module Mixins
    module Create
      def create!(params = {})
        return false if id.present?
        params = params.with_indifferent_access

        @user_id = params['user_id']
        new_obj = custom_create(resource_url, to_hash.merge(params), self.class)
        load_from!(new_obj.to_hash)
      end

      def custom_create(url, params, klass)
        requestor = Requestor.new
        response = requestor.request(url, :post, params)
        Utils.handle_response(response, klass)
      end
    end
  end
end

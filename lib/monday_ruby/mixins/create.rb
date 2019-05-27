# frozen_string_literal: true

module MondayRuby
  module Mixins
    module Create
      def create!(params = {})
        return false if id.present?

        new_obj = custom_create(resource_url, to_hash.merge(params), self.class)
        load_from!(new_obj.to_hash)
      end

      private

      def create_from_nested_obj_array!(path, unpersisted_obj_array)
        return false if unpersisted_obj_array.blank?

        nested_obj_url = Requestor.join_url(resource_url, "/#{id}/#{path}")

        new_parent = nil
        unpersisted_obj_array.each_with_index do |unpersisted_obj, i|
          new_parent = custom_create(nested_obj_url, unpersisted_obj.to_hash.merge(simple_name.to_sym => id), self.class)
        end
        load_from!(new_parent.to_hash)
      end

      def custom_create(url, params, klass)
        requestor = Requestor.new
        response = requestor.request(url, :post, params)
        Utils.handle_response(response, klass)
      end
    end
  end
end

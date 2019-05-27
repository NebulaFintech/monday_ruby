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

      def create_from_nested_obj_array!(path, unpersisted_obj_array, extra_params = {})
        return false if unpersisted_obj_array.blank?

        nested_obj_url = Requestor.join_url(resource_url, "/#{id}/#{path}")

        new_parent = nil
        unpersisted_obj_array.each do |unpersisted_obj|
          params = unpersisted_obj.to_hash.merge(extra_params)
          new_parent = custom_create(nested_obj_url, params, self.class)
        end
        load_from!(new_parent.to_hash)
      end

      def create_nested_obj_array!(klass, unpersisted_obj_array, extra_params = {})
        return false if unpersisted_obj_array.blank?

        nested_obj_url = Requestor.join_url(resource_url, "/#{id}/#{klass.simple_name.pluralize}")

        unpersisted_obj_array.map do |unpersisted_obj|
          params = { klass.simple_name.singularize.to_sym => unpersisted_obj.to_hash }
          params = params.merge(extra_params)
          custom_create(nested_obj_url, params, klass)
        end
      end

      def custom_create(url, params, klass)
        requestor = Requestor.new
        response = requestor.request(url, :post, params)
        Utils.handle_response(response, klass)
      end
    end
  end
end

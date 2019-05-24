# frozen_string_literal: true

module MondayRuby
  module Mixins
    module Create
      def create!(params = {})
        requestor = Requestor.new
        response = requestor.request(resource_url, :post, to_hash.merge(params))
        persisted_obj = Utils.handle_response(response, self.class)
        load_from!(persisted_obj.to_hash)
      end
    end
  end
end

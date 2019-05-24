# frozen_string_literal: true

module MondayRuby
  module Mixins
    module Create
      def create(params = {})
        requestor = Requestor.new
        response = requestor.request(resource_url, :post, to_hash.merge(params))
        Utils.handle_response(response, self.class)
      end
    end
  end
end

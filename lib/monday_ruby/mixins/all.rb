# frozen_string_literal: true

module MondayRuby
  module Mixins
    module All
      module ClassMethods
        def all
          requestor = Requestor.new
          response = requestor.request(resource_url, :get, {})
          Utils.handle_response(response, self)
        end
      end

      def self.included(base)
        base.extend(ClassMethods)
      end
    end
  end
end

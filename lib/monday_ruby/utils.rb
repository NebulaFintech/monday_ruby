# frozen_string_literal: true

module MondayRuby
  module Utils
    def self.handle_response(response, klass)
      if response.is_a?(Array)
        response.map { |r| klass.new r }
      else
        klass.new(response)
      end
    end
  end
end

# frozen_string_literal: true

module MondayRuby
  module Utils
    def self.handle_response(response, klass)
      if response.is_a?(Array)
        response.map { |r| klass.new r }
      else
        # Gross!
        if response.keys.first == klass.simple_name
          klass.new(response[klass.simple_name])
        else
          klass.new(response)
        end
      end
    end
  end
end

# frozen_string_literal: true

module MondayRuby
  class Resource
    attr_reader :id

    def initialize(args)
      @id         = args['id']
      @url        = args['url']
      @created_at = args['created_at']
      @updated_at = args['updated_at']
    end

    def self.resource_url
      name.demodulize.to_s.camelize(:lower).pluralize
    end
  end
end

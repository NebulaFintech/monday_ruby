# frozen_string_literal: true

module MondayRuby
  class Resource
    attr_reader :id, :url, :created_at, :updated_at

    def initialize(args)
      @id         = args['id']
      @url        = args['url']
      @created_at = args['created_at']
      @updated_at = args['updated_at']
    end

    def self.resource_url
      name.demodulize.to_s.camelize(:lower).pluralize
    end

    def resource_url
      self.class.name.demodulize.to_s.camelize(:lower).pluralize
    end

    def to_hash
      {
        id: id,
        url: url,
        created_at: created_at,
        updated_at: updated_at
      }
    end
  end
end

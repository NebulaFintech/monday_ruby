# frozen_string_literal: true

module MondayRuby
  class Resource
    attr_reader :id, :url, :created_at, :updated_at

    def initialize(args)
      load_from!(args)
    end

    def load_from!(args)
      @id         = args['id']
      @url        = args['url']
      @created_at = args['created_at']
      @updated_at = args['updated_at']
    end

    def self.simple_name
      name.demodulize.to_s.camelize(:lower)
    end

    def simple_name
      self.class.name.demodulize.to_s.camelize(:lower)
    end

    def self.resource_url
      simple_name.pluralize
    end

    def resource_url
      simple_name.pluralize
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

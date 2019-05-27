module MondayRuby
  class Column
    VALID_TYPES = ['name', 'status', 'person', 'text', 'date', 'number', 'timeline'].freeze
    attr_reader :id, :title, :type
    def initialize(args = {})
      args   = args.with_indifferent_access
      @id = args['id']
      @title = args['title']
      @type  = args['type']
      validate_type
    end

    def to_hash
      {
        id: id,
        title: title,
        type: type
      }
    end

    private

    def validate_type
      raise ArgumentError, "Invalid type, valid types are: #{VALID_TYPES}" unless VALID_TYPES.include?(type)
    end
  end
end

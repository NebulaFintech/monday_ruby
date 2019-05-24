module MondayRuby
  class Column
    VALID_TYPES = ['name', 'tag', 'person', 'color', 'date', 'timerange', 'dependency', 'multiple-person'].freeze
    attr_reader :title, :type, :width
    def initialize(args = {})
      args   = args.with_indifferent_access
      @title = args['title']
      @type  = args['type']
      @width = 523.005682 if args['type'] == 'name'
      validate_type
    end

    def to_hash
      {
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

module MondayRuby
  class Board < Resource
    include Mixins::Find
    include Mixins::All
    include Mixins::Create

    attr_accessor :name, :description, :columns,
                  :board_kind, :groups

    def initialize(args = {})
      @groups      = []
      @columns     = []
      load_from!(args)
    end

    def load_from!(args)
      args         = args.with_indifferent_access
      @name        = args['name']
      @description = args.fetch('description', '')
      @board_kind  = args.fetch('board_kind', 'public')
      @groups      = args.fetch('groups', [])
      columns      = args.fetch('columns', [])
      super(args)
    end

    def create_with_nested!(params = {})
      unpersisted_columns = @columns.select{ |c| c.id.blank? }
      create!(params)
      # TODO: create nested objs: pulses, columns and groups
      create_from_nested_obj_array!('columns', unpersisted_columns)
    end

    def to_hash
      super.to_hash.merge({
        name: name,
        description: description,
        columns: columns.map(&:to_hash),
        board_kind: board_kind,
        groups: groups.map(&:to_hash),
      })
    end

    def columns=(columns)
      set_columns(columns)
    end

    private

    def set_columns(columns)
      @columns = columns.map do |column|
        if column.is_a?(MondayRuby::Column)
          column
        elsif column.is_a?(Hash)
          MondayRuby::Column.new(column)
        else
          raise ArgumentError, 'Invalid columns types. Valid types are MondayRuby::Column or hash' 
        end
      end.compact
    end
  end
end

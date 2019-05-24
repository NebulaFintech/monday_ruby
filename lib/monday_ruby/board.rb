module MondayRuby
  class Board < Resource
    include Mixins::Find
    include Mixins::All
    include Mixins::Create

    attr_accessor :name, :description, :columns,
                :board_kind, :groups

    def initialize(args = {})
      load_from!(args)
    end

    def load_from!(args)
      args         = args.with_indifferent_access
      @name        = args['name']
      @description = args.fetch('description', '')
      @columns     = args.fetch('columns', [])
      @board_kind  = args.fetch('board_kind', 'public')
      @groups      = args.fetch('groups', [])
      super(args)
    end

    def create_nested!(params = {})
      create(params)
      # TODO: create nested objs: pulses, columns and groups
    end

    def columns=(columns)
      if columns.select{ |c| c.is_a?(MondayRuby::Column) }.present?
        @columns = columns
      elsif columns.select{ |c| c.is_a?(Hash) }.present?
        @columns = columns.map{ |c| MondayRuby::Column.new(c) }
      else
        raise ArgumentError, 'Invalid columns types. Valid types are MondayRuby::Column or hash'
      end
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
  end
end

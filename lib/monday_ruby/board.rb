module MondayRuby
  class Board < Resource
    include Mixins::Find
    include Mixins::All

    attr_reader :name, :description, :columns,
                :board_kind, :groups

    def initialize(args)
      @name        = args['name']
      @description = args['description']
      @columns     = args['columns']
      @board_kind  = args['board_kind']
      @groups      = args['groups']
      super(args)
    end
  end
end
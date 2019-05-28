module MondayRuby
  class Board < Resource
    include Mixins::Find
    include Mixins::All
    include Mixins::Create

    attr_accessor :name, :description, :columns,
                  :board_kind, :groups, :pulses

    attr_reader   :user_id

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
      self.groups  = args.fetch('groups', [])
      self.columns = args.fetch('columns', [])
      self.pulses  = args.fetch('pulses', [])
      super(args)
    end

    def to_hash
      super.to_hash.merge(
        name: name,
        description: description,
        columns: columns.map(&:to_hash),
        board_kind: board_kind,
        groups: groups.map(&:to_hash)
      )
    end

    def columns=(columns)
      set_columns(columns)
    end

    def groups=(groups)
      set_groups(groups)
    end

    def pulses=(pulses)
      set_pulses(pulses)
    end

    private

    def set_columns(columns)
      @columns = columns.map do |column|
        if column.is_a?(MondayRuby::Column)
          column
        elsif column.is_a?(Hash)
          MondayRuby::Column.new(column, id).create!
        else
          raise ArgumentError, 'Invalid columns types. Valid types are MondayRuby::Column or hash'
        end
      end.compact
    end

    def set_pulses(pulses)
      @pulses = pulses.map do |pulse|
        if pulse.is_a?(MondayRuby::Pulse)
          pulse
        elsif pulse.is_a?(Hash)
          MondayRuby::Pulse.new(pulse, id).create!(user_id: user_id)#, group_id: groups.last.id)
        else
          raise ArgumentError, 'Invalid pulses types. Valid types are MondayRuby::Pulse or hash'
        end
      end.compact
    end

    def set_groups(groups)
      @groups = groups.map do |group|
        if group.is_a?(MondayRuby::Group)
          group
        elsif group.is_a?(Hash)
          MondayRuby::Group.new(group, id).create!
        else
          raise ArgumentError, 'Invalid groups types. Valid types are MondayRuby::Group or hash'
        end
      end.compact
    end
  end
end

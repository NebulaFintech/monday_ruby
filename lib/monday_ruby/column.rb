module MondayRuby
  class Column
    include Mixins::Create

    attr_reader :id, :title, :type, :board_id

    def initialize(args = {}, board_id = nil)
      args      = args.with_indifferent_access
      @id       = args['id']
      @title    = args['title']
      @type     = args['type']
      @board_id = board_id
    end

    def resource_url
      raise ArgumentError, 'board_id is not present!' unless board_id

      "boards/#{board_id}/columns"
    end

    def create!(params = {})
      if id.blank?
        new_board = custom_create(resource_url, to_hash.merge(params), MondayRuby::Board)
        @id = new_board.columns.last.id
      end
      self
    end

    def to_hash
      {
        id: id,
        title: title,
        type: type
      }
    end
  end
end

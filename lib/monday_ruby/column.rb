module MondayRuby
  class Column
    include Mixins::Create

    # types: status, person, text, date, numbers or timeline

    attr_reader :id, :title, :type, :board_id, :labels

    def initialize(args = {}, board_id = nil)
      args      = args.with_indifferent_access
      @id       = args['id']
      @title    = args['title']
      @type     = args['type']
      @labels   = args.fetch('labels', [])
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
      h = {
        id: id,
        title: title,
        type: type
      }
      h.merge!(labels: labels) if labels.present?
      h
    end
  end
end

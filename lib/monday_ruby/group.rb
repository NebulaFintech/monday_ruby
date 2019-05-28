module MondayRuby
  class Group < Resource
    include Mixins::Create

    attr_reader :id, :title, :board_id
    def initialize(args = {}, board_id = nil)
      args      = args.with_indifferent_access
      @id       = args['id']
      @title    = args['title']
      @board_id = board_id
    end

    def resource_url
      raise ArgumentError, 'board_id is not present!' unless board_id

      "boards/#{board_id}/groups"
    end

    def create!(params = {})
      if id.blank?
        new_group = custom_create(resource_url, to_hash.merge(params), MondayRuby::Group)
        @id = new_group.id
      end
      self
    end

    def to_hash
      {
        id: id,
        title: title
      }
    end
  end
end

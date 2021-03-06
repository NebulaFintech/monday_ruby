module MondayRuby
  class Pulse < Resource
    include Mixins::Create
    attr_reader :id, :name, :board_id

    def initialize(args = {}, board_id = nil)
      args      = args.with_indifferent_access
      @id       = args['id']
      @name     = args['name']
      @board_id = board_id
    end

    def resource_url
      raise ArgumentError, 'board_id is not present!' unless board_id

      "boards/#{board_id}/pulses"
    end

    def create!(params = {})
      if id.blank?
        new_pulse = custom_create(resource_url, { pulse: to_hash }.merge(params), MondayRuby::Pulse)
        @id = new_pulse.id
      end
      self
    end

    def to_hash
      {
        id: id,
        name: name
      }
    end
  end
end

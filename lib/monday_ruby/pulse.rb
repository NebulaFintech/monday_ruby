module MondayRuby
  class Pulse < Resource
    attr_reader :id, :name
    def initialize(args = {})
      args   = args.with_indifferent_access
      @id = args['id']
      @name = args['name']
    end

    def to_hash
      {
        id: id,
        name: name
      }
    end
  end
end

module MondayRuby
  class Note < Resource
    include Mixins::Create
    attr_reader :id, :project_id, :title, :content, :pulse_id

    def initialize(args = {})
      args      = args.with_indifferent_access
      @id         = args['id']
      @project_id = args['project_id']
      @title      = args['title']
      @content    = args['content']
      @pulse_id   = pulse_id
    end

    def resource_url
      raise ArgumentError, 'project_id is not present!' unless project_id

      "pulses/#{project_id}/notes"
    end

    def create!(params = {})
      if id.blank?
        new_pulse = custom_create(resource_url, to_hash.merge(params), MondayRuby::Note)
        @id = new_pulse.id
      end
      self
    end

    def to_hash
      {
        id: id,
        project_id: project_id,
        title: title,
        content: content
      }
    end
  end
end

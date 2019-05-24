module MondayRuby
  class User < Resource
    include Mixins::Find
    include Mixins::All

    attr_reader :name, :email, :photo_url,
                :title, :position, :phone,
                :location, :status, :birthday,
                :is_guest

    def initialize(args = {})
      args        = args.with_indifferent_access
      @name       = args['name']
      @email      = args['email']
      @photo_url  = args['photo_url']
      @title      = args['title']
      @position   = args['position']
      @phone      = args['phone']
      @location   = args['location']
      @status     = args['status']
      @birthday   = args['birthday']
      @is_guest   = args['is_guest']
      super(args)
    end
  end
end

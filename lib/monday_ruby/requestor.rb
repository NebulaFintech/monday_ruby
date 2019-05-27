# frozen_string_literal: true

module MondayRuby
  class Requestor
    attr_reader :api_key, :connection, :api_base

    def initialize
      raise 'MondayRuby.configure has not been called!' unless MondayRuby.configuration

      @api_key = MondayRuby.configuration.api_key
      raise 'Api key has not been set!' if @api_key.blank?

      @connection = MondayRuby.configuration.connection
      @api_base = self.class.join_url(MondayRuby.configuration.api_base, MondayRuby.configuration.api_version)
    end

    def self.join_url(url, path)
      url.to_s + '/' + path.to_s
    end

    def request(resource_url, http_method, params = {})
      params = params.delete_if { |k, v| v.nil? }
      set_headers_for(connection)
      response = connection.method(http_method).call do |request|
        request.url self.class.join_url(api_base, resource_url + '.json')
        set_request_params(request, params) if params.present?
        set_api_key(request)
      end
      JSON.parse(response.body)
    end

    private

    def set_headers_for(connection)
      connection.headers['Accept'] = 'application/vnd.api+json'
      connection.headers['Cache-Control'] = 'no-cache'
    end

    def set_api_key(request)
      request.params['api_key'] = api_key
    end

    def set_request_params(request, params)
      # Nasty monday's handling params
      request.params = params
    end
  end
end

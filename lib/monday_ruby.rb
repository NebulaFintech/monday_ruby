require 'monday_ruby/version'
require 'monday_ruby/mixins/all'
require 'monday_ruby/mixins/find'
require 'monday_ruby/requestor'
require 'monday_ruby/resource'
require 'monday_ruby/board'
require 'monday_ruby/user'
require 'monday_ruby/utils'

module MondayRuby
  require 'active_support'
  require 'active_support/core_ext'

  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end

  class Configuration
    require 'faraday'
    attr_accessor :api_base, :api_version, :connection, :api_key

    def initialize
      @api_base = 'https://api.monday.com:443'
      @api_version = 'v1'
      @connection = Faraday.new
      @api_key = nil
    end
  end
end

require 'faraday_middleware'
require "multi_json"
require 'forwardable'

#:nocov:
module Headjack
  class Bodysendlogger < Faraday::Response::Middleware
    extend Forwardable

    def initialize(app, logger = nil)
      super(app)
      @logger = logger || begin
        require 'logger'
        ::Logger.new(STDOUT)
      end
    end

    def_delegators :@logger, :debug, :info, :warn, :error, :fatal

    def call(env)
      info "#{env.method} #{env.url}"
      debug "\n\n#{MultiJson.dump(env.body, :pretty => true)}\n\n"
      super
    end

  end
end
#:nocov:

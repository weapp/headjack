require 'faraday_middleware'
require "multi_json"
require 'forwardable'

#:nocov:
module Headjack
  class Bodyreslogger < Faraday::Response::Middleware
    extend Forwardable

    def initialize(app, logger = nil)
      super(app)
      @logger = logger || begin
        require 'logger'
        ::Logger.new(STDOUT)
      end
    end

    def_delegators :@logger, :debug, :info, :warn, :error, :fatal

    def on_complete(env)
      info('Status') { env.status.to_s }
      debug('response') { dump_headers env.response_headers }
      debug env.body
    end

    private

    def dump_headers(headers)
      headers.map { |k, v| "#{k}: #{v.inspect}" }.join("\n")
    end

  end
end
#:nocov:

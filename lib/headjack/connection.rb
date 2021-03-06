require "faraday"

require "headjack/bodyreslogger"
require "headjack/bodysendlogger"

module Headjack
  class Connection
    def initialize opts={}, &block
      default_opts = {url:"http://localhost:7474"}.merge(opts)
      bodylog = default_opts.delete(:bodylog)
      bodysendlog = default_opts.delete(:bodysendlog)
      bodyreslog = default_opts.delete(:bodyreslog)
      @conn = Faraday.new(default_opts) do |conn|
        conn.use Headjack::Bodysendlogger if bodylog || bodysendlog
        conn.request :json
        conn.response :json
        conn.use Headjack::Bodyreslogger if bodylog || bodyreslog

        conn.adapter Faraday.default_adapter

        block.call(conn) if block_given?
      end
    end

    def cypher payload
      Cypher.call(@conn, payload)
    end

    def transaction payload
      Transaction.call(@conn, payload)
    end

    def call opts={}
      mode = opts.delete(:mode){"Transaction"}.to_s.capitalize
      adapter = Headjack.const_get(mode)
      adapter.call(@conn, opts)

      # mode = opts.delete(:mode){:transaction}.to_s
      # send(mode, opts)
    end

  end
end

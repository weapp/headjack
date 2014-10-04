module Headjack
  module DefaultAdapter
    module ClassMethods
      def all_filter result
        result
      end

      def auto_filter result
        all_filter result
      end

      def call conn, payload
        filter = filter_method(payload)
        res = conn.post(endpoint, parse_payload(payload, filter: filter)).body
        send(filter, res)
      end

      def parse_payload payload, _opts={}
        payload
      end

      def one_filter result
        auto_filter(result).first
      end

      private

      def parse_column(column)
        column.is_a?(Hash) && column.has_key?("data") ? column["data"] : column
      end

      def filter_method(payload)
        filter_name = payload.delete(:filter){:auto}.to_s
        "#{filter_name}_filter"
      end
    end

    def self.included base
      base.extend ClassMethods
    end

    extend ClassMethods

  end
end

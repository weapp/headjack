module Headjack
  module Transaction
    include DefaultAdapter

    def self.auto_filter result
      results = result["results"].first

      if results
        if results["columns"]
          
          data = results["data"]

          if results["columns"].count == 1
            data.map{|row| row["row"] && parse_column(row["row"].first)}
          else
            data.map{|row| row["row"] && row["row"].map{|c| parse_column(c)}}
          end
        end
      else
        raise SyntaxError.new(result["errors"].first["message"])
      end
    end

    def self.stats_filter result
      result["results"].first["stats"]
    end

    def self.graph_filter result
      result["results"].first["data"].map{|result| result["graph"]}
    end

    def self.relationships_filter(result)
      graph_filter(result).map{|result| result["relationships"]}.flatten
    end

    def self.relationship_filter(result)
      relationships_filter(result).first
    end

    def self.nodes_filter(result)
      graph_filter(result).map{|result| result["nodes"]}.flatten
    end

    def self.node_filter(result)
      nodes_filter(result).first
    end

    private

    @@resultDataContents = {
      "graph_filter" => ["graph"],
      "relationships_filter" => ["graph"],
      "relationship_filter" => ["graph"],
      "nodes_filter" => ["graph"],
      "node_filter" => ["graph"],
      "all_filter" => ["row", "graph"]
    }

    @@includeStats = {
      "stats_filter" => true,
      "all_filter" => true
    }

    def self.endpoint
      "/db/data/transaction/commit"
    end

    def self.parse_payload payload, opts={}
      auto_fields(parse_statements(payload), opts)
    end

    def self.auto_fields payload, opts
      filter = opts[:filter]
      resultDataContents = @@resultDataContents[filter]
      includeStats = @@includeStats[filter]

      payload.fetch(:statements, []).map do |st|
        st[:resultDataContents] = resultDataContents if resultDataContents && !st.has_key?(:resultDataContents)
        st[:includeStats] = includeStats if includeStats && !st.has_key?(:includeStats)
      end

      payload
    end

    def self.parse_statements payload
      payload[:statement] = payload.delete(:query) if payload.has_key? :query

      if payload.has_key? :statement
        {statements: [payload]}
      else
        payload
      end
    end

  end
end

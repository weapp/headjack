module Headjack
  module Cypher
    include DefaultAdapter

    def self.auto_filter result
      if result["columns"]
        if result["columns"].count == 1
          result["data"].map{|row| parse_column(row.first)}
        else
          result["data"].map{|row| row.map{|c| parse_column(c)}}
        end
      else
        raise SyntaxError.new(result["message"])
      end
    end

    private

    def self.endpoint
      "/db/data/cypher"
    end
  end
end
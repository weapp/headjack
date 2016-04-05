require 'coveralls'
Coveralls.wear!

require 'knapsack'
Knapsack::Adapters::RSpecAdapter.bind

require 'headjack'

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

def double_response body={}
  double("response").tap do |res|
    allow(res).to receive(:body){body}
  end
end

def dobule_connection response={}
  double("Connection").tap do |conn|
    allow(conn).to receive(:post){ double_response(response) }
  end
end


def tr_row c: [], r: []
  r = r.map{ |row| {"row" => row} }
  {"results" => [ {"columns" => c, "data" => r} ] }
end

# Headjack

A ruby query builder for chypher and neo4j

[![Code Climate](https://codeclimate.com/github/weapp/headjack/badges/gpa.svg)](https://codeclimate.com/github/weapp/headjack)
[![Build Status](https://secure.travis-ci.org/weapp/headjack.png?branch=master)](http://travis-ci.org/weapp/headjack)
[![Coverage Status](https://coveralls.io/repos/weapp/headjack/badge.png?branch=master)](https://coveralls.io/r/weapp/headjack)


## Installation

Add this line to your application's Gemfile:

    gem 'headjack'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install headjack

## Usage


### Create connection

    conn = Headjack::Connection.new

### Querying to cypher endpoint

    conn.cypher(query: "MATCH (n:Label) RETURN n LIMIT 25")
    conn.call(query: "MATCH (n:Label) RETURN n LIMIT 25", mode: :cypher)

### Querying to transaction endpoint (prefered)

    conn.transaction(query: "MATCH (n:Label) RETURN n LIMIT 25")
    conn.call(query: "MATCH (n:Label) RETURN n LIMIT 25")
    conn.(query: "MATCH (n:Label) RETURN n LIMIT 25")

### Filters

    conn.call(query: "MATCH (n:Label) RETURN n LIMIT 25", filter: :all)
    conn.call(query: 'CREATE (Neo:Crew {name:"Neo"}), (Morpheus:Crew {name: "Morpheus"}), (Trinity:Crew {name: "Trinity"}), (Neo)-[:KNOWS]->(Morpheus), (Neo)-[:LOVES]->(Trinity), (Morpheus)-[:KNOWS]->(Trinity)', filter: :all)
    conn.call(query: 'CREATE (n:Label {name:"Hello World"}) RETURN n', filter: :stats)
    conn.call(query: "MATCH (n:Crew)-[r]->() RETURN n, r LIMIT 25", filter: :graph)
    conn.call(query: "MATCH (n:Crew)-[r]->() RETURN n, r LIMIT 25", filter: :relationships)

## Contributing

1. Fork it ( http://github.com/<my-github-username>/headjack/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

require 'spec_helper'

module Headjack
  describe Cypher do
    let(:dummy) { Object.new }

    describe "::all_filter" do
      it{ expect(Cypher.all_filter(Object)).to be Object }
    end

    describe "::auto_filter" do
      it{ expect(Cypher.auto_filter("columns"=>["1"], "data"=>[])).to eq [] }
      it{ expect(Cypher.auto_filter("columns"=>["1"], "data"=>[[1]])).to eq [1] }
      it{ expect(Cypher.auto_filter("columns"=>["1"], "data"=>[[1],[2]])).to eq [1, 2] }
      it{ expect(Cypher.auto_filter("columns"=>["1"], "data"=>[[{"data"=>1}]])).to eq [1] }
      it{ expect(Cypher.auto_filter("columns"=>["1"], "data"=>[[{}]])).to eq [{}] }

      it{ expect(Cypher.auto_filter("columns"=>["1", "2"], "data"=>[[1, 2]])).to eq [[1, 2]] }
      it{ expect(Cypher.auto_filter("columns"=>["1", "2"], "data"=>[[1, 2],[2, 3]])).to eq [[1, 2],[2, 3]] }

      it{ expect{Cypher.auto_filter("message"=>"error")}.to raise_error(SyntaxError) }
    end

    describe "::one_filter" do
      it{ expect(Cypher.one_filter("columns"=>["1"], "data"=>[])).to eq nil }
      it{ expect(Cypher.one_filter("columns"=>["1"], "data"=>[[1]])).to eq 1 }
      it{ expect(Cypher.one_filter("columns"=>["1"], "data"=>[[1],[2]])).to eq 1 }
      it{ expect(Cypher.one_filter("columns"=>["1"], "data"=>[[{"data"=>1}]])).to eq 1 }
      it{ expect(Cypher.one_filter("columns"=>["1"], "data"=>[[{}]])).to eq Hash.new }

      it{ expect(Cypher.one_filter("columns"=>["1", "2"], "data"=>[[1, 2]])).to eq [1, 2] }
      it{ expect(Cypher.one_filter("columns"=>["1", "2"], "data"=>[[1, 2],[2, 3]])).to eq [1, 2] }

      it{ expect{Cypher.one_filter("message"=>"error")}.to raise_error(SyntaxError) }
    end

    it{ expect(Cypher.call(dobule_connection("columns"=>["1"], "data"=>[]), {})).to eq [] }

  end
end

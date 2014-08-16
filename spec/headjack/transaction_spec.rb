require 'spec_helper'

module Headjack
  describe Transaction do
    let(:dummy) { Object.new }
    let(:node) { double("node") }
    let(:rel) { double("rel") }
    let(:dummy_response) { {"results" => [ {"columns"=>["true"], "data"=>[{"row"=>[true]}]} ] } }

    describe "::all_filter" do
      it { expect(Transaction.all_filter(dummy)).to be dummy }
    end

    describe "::auto_filter" do
      it { expect(Transaction.auto_filter tr_row()).to eq [] }
      it { expect(Transaction.auto_filter tr_row(c:["1"], r:[])).to eq [] }
      it { expect(Transaction.auto_filter tr_row(c:["1"], r:[[1]])).to eq [1] }

      it { expect(Transaction.auto_filter tr_row(c:["1"], r:[[1],[2]])).to eq [1, 2] }
      it { expect(Transaction.auto_filter tr_row(c:["1"], r:[[{"data"=>1}]])).to eq [1] }
      it { expect(Transaction.auto_filter tr_row(c:["1"], r:[[{}]])).to eq [{}] }

      it { expect(Transaction.auto_filter tr_row(c:["1", "2"], r:[[1, 2]])).to eq [[1, 2]] }
      it { expect(Transaction.auto_filter tr_row(c:["1", "2"], r:[[1, 2],[2, 3]])).to eq [[1, 2],[2, 3]] }

      it { expect{Transaction.auto_filter("results"=>[], "errors"=>["error"])}.to raise_error(SyntaxError) }
    end

    describe "::one_filter" do
      it { expect(Transaction.one_filter tr_row(c:["1"], r:[])).to eq nil }
      it { expect(Transaction.one_filter tr_row(c:["1"], r:[[1]])).to eq 1 }
      it { expect(Transaction.one_filter tr_row(c:["1"], r:[[1],[2]])).to eq 1 }
      it { expect(Transaction.one_filter tr_row(c:["1"], r:[[{"data"=>1}]])).to eq 1 }
      it { expect(Transaction.one_filter tr_row(c:["1"], r:[[{}]])).to eq Hash.new }

      it { expect(Transaction.one_filter tr_row(c:["1", "2"], r:[[1, 2]])).to eq [1, 2] }
      it { expect(Transaction.one_filter tr_row(c:["1", "2"], r:[[1, 2],[2, 3]])).to eq [1, 2] }

      it { expect{Transaction.one_filter("results"=>[], "errors"=>["error"])}.to raise_error(SyntaxError) }
    end

    describe "::stats_filter" do
      it { expect(Transaction.stats_filter("results"=>["stats"=> dummy])).to be dummy }
    end
    
    describe "graph filters" do
      let(:example_graph_result){ {"results"=>["data"=>["graph"=>{"nodes"=>[node], "relationships"=>[rel, rel]}]]} }

      describe "::graph_filter" do
        it { expect(Transaction.graph_filter(example_graph_result)).to eq [{"nodes"=>[node], "relationships"=>[rel, rel]}] }
      end
      
      describe "::relationships_filter" do
        it { expect(Transaction.relationships_filter(example_graph_result)).to eq [rel, rel] }
      end

      describe "::relationship_filter" do
        it { expect(Transaction.relationship_filter(example_graph_result)).to eq rel }
      end
      
      describe "::nodes_filter" do
        it { expect(Transaction.nodes_filter(example_graph_result)).to eq [node] }
      end

      describe "::node_filter" do
        it { expect(Transaction.node_filter(example_graph_result)).to eq node }
      end
    end

    it { expect(Transaction.call(dobule_connection(tr_row(c:["1"], r:[])), {})).to eq [] }

  end
end

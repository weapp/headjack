require 'spec_helper'

module Headjack
  describe Connection do
    let(:q1){"RETURN true"}
    let(:match_rel){
      match(
        "id" => String,
        "type" => "TYPE",
        "startNode" => String,
        "endNode" => String,
        "properties" => {}
      )
    }
    let(:match_node){
      match(
        "id" => String,
        "labels" => ["Test"],
        "properties" => {}
      )
    }

    it { is_expected.to be_truthy }

    describe "#cypher" do
      it { expect(subject.cypher(query: q1, filter: :all)).to eq "columns"=>["true"], "data"=>[[true]] }
    end

    describe "#call" do
      it { expect(subject.call(query: q1, mode: :cypher, filter: :all)).to eq "columns"=>["true"], "data"=>[[true]] }
    end

    describe "#cypher" do
      it { expect(subject.cypher(query: q1)).to eq [true] }
    end

    describe "#call" do
      it { expect(subject.transaction(query: Object.new.tap{|o| def o.to_s;"RETURN true";end } )).to eq [true] }

      it { expect(subject.call(query: q1, mode: :cypher)).to eq [true] }
     
      it { expect(subject.call(query: q1, mode: :cypher, filter: :all)).to include("columns", "data") }

      it { expect(subject.call(query: q1, mode: :transaction)).to eq [true] }

      it { expect(subject.call(query: q1, mode: :transaction, filter: :all)).to include("results", "errors")}

      it { expect(subject.call(query: q1, filter: :all)).to include("results", "errors")}
    end

    describe "#transaction" do
      let (:dummy_results){ [ {"columns"=>["true"], "data"=>[{"row"=>[true]}]} ] }

      it {
        expect(subject.transaction(statements: [statement: q1])).to eq [true]
      }

      it {
        expect(subject.transaction(statements: [statement: q1], filter: :one)).to eq true
      }

      it {
        expect(subject.transaction(statement: q1, filter: :one)).to eq true
      }

      it {
        expect(subject.transaction(query: q1, filter: :one)).to eq true
      }

     
      it {
        expect(subject.transaction(query: q1, filter: :one)).to eq true
      }

      describe "result of transaction" do
        let(:stats_result){ subject.transaction(query: q1, filter: :stats) }

        let(:all_result){ subject.transaction(query: q1, filter: :all) }

        let(:error_result){ subject.transaction(query: "ERROR") }

        it { expect(stats_result["contains_updates"]).to be false }
        it { expect(stats_result["contains_updates"]).to be false }
        it { expect(stats_result["nodes_created"]).to be_zero }
        it { expect(stats_result["nodes_deleted"]).to be_zero }
        it { expect(stats_result["properties_set"]).to be_zero }
        it { expect(stats_result["relationships_created"]).to be_zero }
        it { expect(stats_result["relationship_deleted"]).to be_zero }
        it { expect(stats_result["labels_added"]).to be_zero }
        it { expect(stats_result["labels_removed"]).to be_zero }
        it { expect(stats_result["indexes_added"]).to be_zero }
        it { expect(stats_result["indexes_removed"]).to be_zero }
        it { expect(stats_result["constraints_added"]).to be_zero }
        it { expect(stats_result["constraints_removed"]).to be_zero }

        it { expect(all_result["results"].first["columns"]).to eq(["true"]) }
       
        it { expect(all_result["results"].first["data"].first["row"]).to eq([true]) }

        it { expect(all_result["results"].first["data"].first["graph"]["nodes"]).to be_empty }
        it { expect(all_result["results"].first["data"].first["graph"]["relationships"]).to be_empty }


        it { expect(all_result["errors"]).to eq([]) }

        it { expect{error_result}.to raise_error(SyntaxError) }

      end


      describe "graph filter" do
        it{
          expect(
            subject.transaction(
              statements: [
                {statement:"CREATE (a:Test {name: \"A\" }) RETURN a"},
                {statement:"ROLLBACK"}
              ],
              filter: :graph
            )
          ).to match([
            "relationships" => [],
            "nodes" => [
              {"id"=> String, "labels"=> ["Test"], "properties"=> {"name"=>"A"}} ]
            ]
          )
        }

        it{
          expect(
            subject.transaction(
              statements: [
                {statement:"CREATE (a:Test)-[r:TYPE]->(b:Test {}) RETURN r"},
                {statement:"ROLLBACK"}
              ],
              filter: :graph
            )
          ).to match(["nodes"=>[match_node, match_node], "relationships"=>[match_rel]])
        }
      end

      describe "relationships filter" do
        it{
          expect(
            subject.transaction(
              statements: [
                {statement:"CREATE (a:Test)-[r:TYPE]->(b:Test {}) RETURN r"},
                {statement:"ROLLBACK"}
              ],
              filter: :relationships
            )
          ).to match([match_rel])
        }
      end

      describe "relationship filter" do
        it{
          expect(
            subject.transaction(
              statements: [
                {statement:"CREATE (a:Test)-[r:TYPE]->(b:Test {}) RETURN r"},
                {statement:"ROLLBACK"}
              ],
              filter: :relationship
            )
          ).to match_rel
        }
      end

    end
  end
end

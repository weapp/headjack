require 'spec_helper'

module Headjack
  describe DefaultAdapter do
    let(:dummy) { Object.new.object_id }

    describe "::all_filter" do
      it { expect(DefaultAdapter.all_filter(dummy)).to be dummy }
    end

    describe "::auto_filter" do
      it { expect(DefaultAdapter.all_filter(dummy)).to be dummy }
    end

    describe "::parse_payload" do
      it { expect(DefaultAdapter.parse_payload(dummy)).to be dummy }
    end

    describe "::call" do
      it { 
        expect(DefaultAdapter).to receive(:endpoint)
        expect(DefaultAdapter.call(dobule_connection, {})).to eq Hash.new
      }
    end

  end
end

require 'spec_helper'

describe Bustime, :vcr do
  it "should have access to the API key" do
    expect(ENV['CTA_API_KEY']).to be_present
  end

  describe "busroutes" do
    before { @busroutes = Bustime.new.busroutes }

    it "should return an array (of hashes) of all busroutes" do
      expect(@busroutes.kind_of?(Array)).to be true
    end

    it "should contain 147 Outer Drive Express" do
      expect(@busroutes.select { |bus| bus["rt"] == "147" }.length).to eq(1)
    end
  end

  describe "busdirections" do
    before { @busdirections = Bustime.new.busdirections(147) }

    it "should return an array of hashes with directions for a particular route" do
      expect(@busdirections.kind_of?(Array)).to be true
    end

    it "should return North Bound as one of the directions for the 147 route" do
      expect(@busdirections.select { |dir| dir["dir"] == "Northbound"}.length).to eq(1)
    end
  end

  describe "busstops" do
    before { @busstops = Bustime.new.busstops(147,'Northbound') }

    it "should return an array of hashes of busstops for supplied route and direction" do
      expect(@busstops.kind_of?(Array)).to be true
    end

    it "should contain Michigan and Huron for 147 North Bound" do
      expect(@busstops.select { |stpid| stpid["stpnm"] == "Michigan & Huron" }.length).to eq(1)
    end
  end

  describe "buspredictions" do
    before { @buspredictions = Bustime.new.buspredictions(147,'Northbound',1125) }

    it "should return an array of hashes with predictions for supplied route, direction and stopid" do
      expect(@buspredictions.kind_of?(Array)).to be true
    end

    it "should contain the stopname in the predictions" do
      expect(@buspredictions.select { |stpnm| stpnm["stpnm"] == "Michigan & Huron" }.length).to be > 0
    end
  end
end

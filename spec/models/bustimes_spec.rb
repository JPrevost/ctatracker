require 'spec_helper'

describe Bustime, :vcr do

  it "should have access to the API key" do
    expect do
      ENV['CTA_API_KEY'].defined?
    end.to be_true
  end

  describe "busroutes" do
    before { @busroutes = Bustime.new.busroutes }

    it "should return an array (of hashes) of all busroutes" do
      @busroutes.kind_of?(Array).should be_true
    end

    it "should contain 147 Outer Drive Express" do
      @busroutes.select { |bus| bus["rt"] == "147" }.length().should equal 1
    end

  end

  describe "busdirections" do
    before { @busdirections = Bustime.new.busdirections(147) }

    it "should return an array of hashes with directions for a particular route" do
      @busdirections.kind_of?(Array).should be_true
    end

    it "should return North Bound as one of the directions for the 147 route" do
      @busdirections.select { |dir| dir["dir"] == "Northbound"}.length().should equal 1
    end

  end

  describe "busstops" do

    before { @busstops = Bustime.new.busstops(147,'Northbound') }

    it "should return an array of hashes of busstops for supplied route and direction" do
      @busstops.kind_of?(Array).should be_true
    end

    it "should contain Michigan and Huron for 147 North Bound" do
      @busstops.select { |stpid| stpid["stpnm"] == "Michigan & Huron" }.length().should equal 1
    end

  end

  describe "buspredictions" do
    before { @buspredictions = Bustime.new.buspredictions(147,'Northbound',1125) }

    it "should return an array of hashes with predictions for supplied route, direction and stopid" do
      @buspredictions.kind_of?(Array).should be_true
    end

    it "should contain the stopname in the predictions" do
      @buspredictions.select { |stpnm| stpnm["stpnm"] == "Michigan & Huron" }.length().should > 0
    end

  end

end
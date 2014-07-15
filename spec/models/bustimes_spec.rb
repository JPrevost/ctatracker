require 'spec_helper'

describe Bustime, :vcr do
  describe 'busroutes' do
    before { @busroutes = Bustime.new.busroutes }

    it 'returns an array (of hashes) of all busroutes' do
      expect(@busroutes.is_a?(Array)).to be true
    end

    it 'contains 147 Outer Drive Express' do
      expect(@busroutes.select { |bus| bus['rt'] == '147' }.length).to eq(1)
    end
  end

  describe 'busdirections' do
    before { @busdirections = Bustime.new.busdirections(147) }

    it 'returns an array of hashes with directions for a particular route' do
      expect(@busdirections.is_a?(Array)).to be true
    end

    it 'returns North Bound as one of the directions for the 147 route' do
      expect(@busdirections.select { |dir| dir['dir'] == 'Northbound' }
        .length).to eq(1)
    end
  end

  describe 'busstops' do
    before { @busstops = Bustime.new.busstops(147, 'Northbound') }

    it 'returns an array of hashes of busstops' do
      expect(@busstops.is_a?(Array)).to be true
    end

    it 'contains Michigan and Huron for 147 North Bound' do
      expect(@busstops.select { |stpid| stpid['stpnm'] == 'Michigan & Huron' }
        .length).to eq(1)
    end
  end

  describe 'buspredictions' do
    before do
      @buspredictions = Bustime.new.buspredictions(147, 'Northbound', 1125)
    end

    it 'returns an array of hashes with predictions' do
      expect(@buspredictions.is_a?(Array)).to be true
    end

    it 'contains the stopname in the predictions' do
      expect(@buspredictions.select { |s| s['stpnm'] == 'Michigan & Huron' }
        .length).to be > 0
    end
  end
end

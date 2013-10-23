require 'spec_helper'

describe "BustimePages", :vcr do

  subject { page }

  before { visit root_path }

  describe "Home page" do

    it { find_link('147 Outer Drive Express').visible?.should equal true }

    describe "clicking 147 bus" do

      before { click_link('147 Outer Drive Express') }

      it { find_link('Northbound').visible?.should equal true }

      it "should display route information" do
        page.should have_content "147 Outer Drive Express"
      end

      describe "clicking Northbound" do

        before { click_link('Northbound') }

        it { find_link('Michigan & Huron').visible?.should equal true }

        describe "Clicking Michigan & Huron" do
          before { click_link('Michigan & Huron') }

          it { should have_content('Refresh') }
        end
      end
    end
  end
end

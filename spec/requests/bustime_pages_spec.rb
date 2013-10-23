require 'spec_helper'

describe "BustimePages", :vcr do

  subject { page }

  before { visit root_path }

  describe "Home page" do

    it "should have a breadcrumb" do
      page.should have_content "Choose a Route"
    end

    it "should display links to various routes" do
     page.should have_link('147 Outer Drive Express', :href => busdirections_path(147,'Outer Drive Express'))
     page.should have_link('66 Chicago', :href => busdirections_path(66,'Chicago'))
    end

    describe "clicking 147 bus" do

      before { click_link('147 Outer Drive Express') }

      it "should have a breadcrumb" do
        page.should have_content "Route Choose a Direction"
      end

      it "should have direction links" do
        page.should have_link('Northbound', :href => busstops_path(147,'Outer Drive Express', 'Northbound'))
        page.should have_link('Southbound', :href => busstops_path(147,'Outer Drive Express', 'Southbound'))
      end

      it "should display route information" do
        page.should have_content "147 Outer Drive Express"
      end

      describe "clicking Northbound" do

        before { click_link('Northbound') }

        it "should have a breadcrumb" do
          page.should have_content "Route Direction Choose a Stop"
        end

        it "should list bus stops" do
          page.should have_link('Michigan & Huron', :href => buspredictions_path(147,'Outer Drive Express', 'Northbound', 1125, 'Michigan & Huron'))
          page.should have_link('Congress & Michigan', :href => buspredictions_path(147,'Outer Drive Express', 'Northbound', 4725, 'Congress & Michigan'))
        end


        describe "Clicking Michigan & Huron" do
          before { click_link('Michigan & Huron') }

          it "should have a breadcrumb" do
            page.should have_content "Route Direction Stop Upcoming Buses"
          end

          it "should display route and stop information" do
            page.should have_content "147 Outer Drive Express, Northbound, Michigan & Huron"
          end

          it "should display bus predictions" do
            page.should have_content "2 Min (to Howard Station)"
            page.should have_content "28 Min (to Howard Station)"
          end

          it { should have_content('Refresh') }

          it "should have more info links to bus detail" do
            pending
          end
        end
      end
    end
  end
end

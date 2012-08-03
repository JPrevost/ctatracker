require 'spec_helper'

describe "BustimePages" do

	subject { page }

	describe "Home page" do
	
		before { visit root_path }
	
		it { should have_selector('h2', text: 'Choose a route') }
		
		it { find_link('Choose a Route').visible?.should equal true }
	
		it { find_link('147 Outer Drive Express').visible?.should equal true }

		describe "clicking 147 bus" do
			
			before { click_link('147 Outer Drive Express') }
			
			it { find_link('North Bound').visible?.should equal true }
			
			describe "clicking North Bound" do
			
				before { click_link('North Bound') }	
			
				it { find_link('Michigan & Huron').visible?.should equal true }
			
				describe "Clicking Michigan & Huron" do
					
					before { click_link('Michigan & Huron') }
					
					it { should have_content('Refresh') }
					
				end
			
			end
			
		end
		
	end
	
end
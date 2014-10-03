require 'spec_helper'

describe 'BustimePages', :vcr do
  subject { page }
  before { visit root_path }

  describe 'Home page' do
    it 'should have a breadcrumb' do
      expect(page).to have_content('Choose a Route')
    end

    it 'should display links to various routes' do
      expect(page).to have_link('147 Outer Drive Express', href:
        busdirections_path(147, 'Outer Drive Express'))
      expect(page).to have_link('66 Chicago',
                                href: busdirections_path(66, 'Chicago'))
    end

    describe 'clicking 147 bus' do
      before { click_link('147 Outer Drive Express') }

      it 'should have a breadcrumb' do
        expect(page).to have_content 'Route Choose a Direction'
      end

      it 'should have direction links' do
        expect(page).to have_link('Northbound', href:
          busstops_path(147, 'Outer Drive Express', 'Northbound'))
        expect(page).to have_link('Southbound', href:
          busstops_path(147, 'Outer Drive Express', 'Southbound'))
      end

      it 'should display route information' do
        expect(page).to have_content '147 Outer Drive Express'
      end

      describe 'clicking Northbound' do
        before { click_link('Northbound') }

        it 'should have a breadcrumb' do
          expect(page).to have_content 'Route Direction Choose a Stop'
        end

        it 'should list bus stops' do
          expect(page).to have_link('Michigan & Huron', href:
            buspredictions_path(147, 'Outer Drive Express', 'Northbound', 1125,
                                'Michigan & Huron'))
          expect(page).to have_link('Congress & Michigan', href:
            buspredictions_path(147, 'Outer Drive Express', 'Northbound', 4725,
                                'Congress & Michigan'))
        end

        describe 'Clicking Michigan & Huron' do
          before { click_link('Michigan & Huron') }

          it 'should have a breadcrumb' do
            expect(page).to have_content 'Route Direction Stop Upcoming Buses'
          end

          it 'should display route and stop information' do
            expect(page).to have_content(
              '147 Outer Drive Express, Northbound, Michigan & Huron')
          end

          it 'should display bus predictions' do
            expect(page).to have_content '2 Min (to Howard Station)'
            expect(page).to have_content '28 Min (to Howard Station)'
          end

          it { should have_content('Refresh') }

          it 'should have more info links to bus detail' do
            expect(page).to have_link('More Info', href: '#modal-4077')
          end
        end
      end
    end
  end

  describe 'recent stops' do
    it 'contains no recent stops initially' do
      visit root_path
      expect(page).to_not have_content('Recent Stops')
    end

    it 'remembers recently used stops' do
      visit buspredictions_path('147', 'Outer Drive Express', 'Northbound',
                                '1125', 'Michigan & Huron')
      visit root_path
      expect(page).to have_content('Recent Stops')
      expect(page).to have_link(
        '147 Outer Drive Express, Northbound, Michigan & Huron')
    end

    it 'only remembers 6 recent stops and removes the least recently used' do
      visit buspredictions_path('147', 'Outer Drive Express', 'Northbound',
                                '1125', 'Michigan & Huron')
      visit buspredictions_path('147', 'Outer Drive Express', 'Southbound',
                                '1041', 'Sheridan & Berwyn')
      visit buspredictions_path('66', 'Chicago', 'Westbound', '596',
                                'Fairbanks & Chicago')
      visit buspredictions_path('66', 'Chicago', 'Eastbound', '530',
                                'Chicago & Pulaski')
      visit buspredictions_path('146', 'Inner Drive/Michigan Express',
                                'Northbound', '4877',
                                'Solidarity Dr & Planetarium')
      visit buspredictions_path('146', 'Inner Drive/Michigan Express',
                                'Southbound', '4846', 'Foster & Marine Drive')
      visit root_path
      expect(page).to have_content('Recent Stops')
      expect(page).to have_link(
        '147 Outer Drive Express, Northbound, Michigan & Huron')
      expect(page).to have_link(
        '147 Outer Drive Express, Southbound, Sheridan & Berwyn')
      expect(page).to have_link('66 Chicago, Westbound, Fairbanks & Chicago')
      expect(page).to have_link('66 Chicago, Eastbound, Chicago & Pulaski')
      expect(page).to have_link(
        '146 Inner Drive/Michigan Express, Northbound, Solidarity Dr & Planeta')
      expect(page).to have_link(
        '146 Inner Drive/Michigan Express, Southbound, Foster & Marine Drive')

      visit buspredictions_path('147', 'Outer Drive Express', 'Northbound',
                                '1123', 'Michigan & Grand')
      visit root_path
      expect(page).to_not have_link(
        '147 Outer Drive Express, Northbound, Michigan & Huron')
      expect(page).to have_link(
        '147 Outer Drive Express, Northbound, Michigan & Grand')
    end

    it 'only remembers unique recent stops' do
      visit buspredictions_path('66', 'Chicago', 'Westbound', '596',
                                'Fairbanks & Chicago')
      visit buspredictions_path('66', 'Chicago', 'Westbound', '596',
                                'Fairbanks & Chicago')
      visit root_path
      expect(page).to have_link('66 Chicago, Westbound, Fairbanks & Chicago',
                                count: 1)
    end

    it 'moves the most recent stop to the first position' do
      visit buspredictions_path('66', 'Chicago', 'Westbound', '596',
                                'Fairbanks & Chicago')
      visit buspredictions_path('147', 'Outer Drive Express', 'Northbound',
                                '1125', 'Michigan & Huron')
      visit root_path

      within '#recent_stops' do
        expect(page).to have_selector('li:nth-child(1)', text: 'Huron')
        expect(page).to have_selector('li:nth-child(2)', text: 'Fairbanks')
      end

      visit buspredictions_path('66', 'Chicago', 'Eastbound', '530',
                                'Chicago & Pulaski')
      visit root_path

      within '#recent_stops' do
        expect(page).to have_selector('li:nth-child(1)', text: 'Pulaski')
        expect(page).to have_selector('li:nth-child(2)', text: 'Huron')
        expect(page).to have_selector('li:nth-child(3)', text: 'Fairbanks')
      end
    end
  end
end

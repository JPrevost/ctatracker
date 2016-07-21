Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root :to => 'bustimes#busroutes'

	get 'bustimes/clearlocalstorage' => 'bustimes#clearlocalstorage'
	get 'bustimes/:id/:rtnm' => 'bustimes#busdirections', :as => "busdirections"
	get 'bustimes/:id/:rtnm/:dir' => 'bustimes#busstops', :as => "busstops"
	get 'bustimes/:id/:rtnm/:dir/:stopid/:stpnm' => 'bustimes#buspredictions', :as => "buspredictions"
end

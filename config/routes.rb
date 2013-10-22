Ctatracker::Application.routes.draw do

  root :to => 'bustimes#busroutes'

	get 'bustimes/clearlocalstorage' => 'bustimes#clearlocalstorage'
	get 'bustimes/:id/:rtnm' => 'bustimes#busdirections', :as => "busdirections"
	get 'bustimes/:id/:rtnm/:dir' => 'bustimes#busstops', :as => "busstops"
	get 'bustimes/:id/:rtnm/:dir/:stopid/:stpnm' => 'bustimes#buspredictions', :as => "buspredictions"

end

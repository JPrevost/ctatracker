Ctatracker::Application.routes.draw do

  root :to => 'bustimes#busroutes'

	get 'bustimes/clearlocalstorage' => 'bustimes#clearlocalstorage'
	get 'bustimes/:id' => 'bustimes#busdirections'
	get 'bustimes/:id/:dir' => 'bustimes#busstops'
	get 'bustimes/:id/:dir/:stopid' => 'bustimes#buspredictions'

end

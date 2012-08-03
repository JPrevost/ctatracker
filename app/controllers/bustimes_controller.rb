class BustimesController < ApplicationController
  def busroutes
  	@busroutes = Bustime.new.busroutes
  end

  def busdirections
  	@busdirections = Bustime.new.busdirections(params[:id])
  end

  def busstops
  	@busstops = Bustime.new.busstops(params[:id],params[:dir])
  end

  def buspredictions
  	@buspredictions = Bustime.new.buspredictions(params[:id],params[:dir],params[:stopid])
  end
end

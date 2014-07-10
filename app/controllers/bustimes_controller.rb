class BustimesController < ApplicationController
  def busroutes
  	@busroutes = Bustime.new.busroutes
  end

  def busdirections
  	@busdirections = Bustime.new.busdirections( params[:id] )
  end

  def busstops
  	@busstops = Bustime.new.busstops( params[:id], params[:dir] )
  end

  def buspredictions
    set_recent_stops_cookie(params[:id], params[:rtnm], params[:dir], params[:stopid], params[:stpnm])
  	@buspredictions = Bustime.new.buspredictions( params[:id], params[:dir], params[:stopid] )
  end

  def set_recent_stops_cookie(id, rtnm, dir, stopid, stpnm)
    cookies[:recent_stops] = {
      value: ActiveSupport::JSON.encode(append_cookie_value(id, rtnm, dir, stopid, stpnm)),
      expires: 1.year.from_now
    }
  end

  def read_recent_stops_cookie
    begin
      ActiveSupport::JSON.decode(cookies[:recent_stops])
    rescue TypeError
      []
    end
  end

  def append_cookie_value(id, rtnm, dir, stopid, stpnm)
    recent_stops = read_recent_stops_cookie
    if recent_stops.count > 5
      recent_stops.pop
    end
    stop = { "route" => id, "route_name" => rtnm, "dir" => dir,
      "stopid" => stopid, "stpnm" => stpnm }
    recent_stops.unshift(stop).uniq
  end
end

class Bustime

	require 'nokogiri'
	require 'open-uri'
	
	def busroutes
		#sample: http://www.ctabustracker.com/bustime/api/v1/getroutes?key=APIKEY
	
		apiurl = "http://www.ctabustracker.com/bustime/api/v1/getroutes?key=" + ENV['CTA_API_KEY']
		
		doc = Nokogiri::XML(open(apiurl))

		allroutes = doc.xpath('//route').map do |i|
      {'rt' => i.xpath('rt').inner_text, 'rtnm' => i.xpath('rtnm').inner_text}
    end
	
		return allroutes
	
	end
	
	def busdirections(rt)
		#sample: http://www.ctabustracker.com/bustime/api/v1/getdirections?key=APIKEY&rt=147
	  # list directions for one route (147)
		doc = Nokogiri::XML(open('http://www.ctabustracker.com/bustime/api/v1/getdirections?key=' + ENV['CTA_API_KEY'] + '&rt=' + rt.to_s ))

		directions = doc.xpath('//dir').map do |i|
			{'dir' => i.inner_text }
			end

		return directions

	end
	
	def busstops(rt,dir)
		#sample http://www.ctabustracker.com/bustime/api/v1/getstops?key=APIKEY&rt=147&dir=North%20Bound
		
		# list stops for one route direction (147 southbound)
    doc = Nokogiri::XML(open('http://www.ctabustracker.com/bustime/api/v1/getstops?key=' + ENV['CTA_API_KEY'] + '&rt=' + rt.to_s + '&dir=' + URI::encode(dir)))
    
    stops = doc.xpath('//stop').map do |i|
    	{'stpid' => i.xpath('stpid').inner_text, 'stpnm' => i.xpath('stpnm').inner_text}
    end
      
		return stops
		
	end
	
	def buspredictions(rt,dir,stpid)
		#sample http://www.ctabustracker.com/bustime/api/v1/getpredictions?key=APIKEY&rt=147&dir=North%20Bound&stpid=1125
	
		doc = Nokogiri::XML(open('http://www.ctabustracker.com/bustime/api/v1/getpredictions?key=' + ENV['CTA_API_KEY'] + '&rt=' + rt.to_s + '&dir=' + URI::encode(dir) + '&stpid=' + stpid.to_s))

		predictions = doc.xpath('//prd').map do |i|
      {'tmstmp' => i.xpath('tmstmp').inner_text, 
      	'stpnm' => i.xpath('stpnm').inner_text,
      	'vid' => i.xpath('vid').inner_text,
      	'rt' => i.xpath('rt').inner_text,
      	'rtdir' => i.xpath('rtdir').inner_text,
      	'des' => i.xpath('des').inner_text,
      	'prdtm' => i.xpath('prdtm').inner_text,
      }      	
      end

		return predictions
	end
	
	def persisted?
		false
  	end
	

end
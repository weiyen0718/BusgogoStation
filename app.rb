require 'sinatra/base'
require 'json'


require 'bundler/setup'
require 'haml'
require 'sinatra/flash'

require 'httparty'
#require './tutorials'

class Bus < Sinatra::Base
	enable :sessions
	register Sinatra::Flash
      use Rack::MethodOverride

		configure :production, :development do
		enable :logging
		end

      configure :development do
      set :session_secret, "something" # ignore if not using shotgun in    development
      end
   
      API_BASE_URI= 'https://busgogostations.herokuapp.com'
      API_VER = '/api/v2/'
	helpers do
#def user
#num = params[:num].to_i
# @station = user
#return nil unless num
#profile_after={
#'station' => num,
#'profiles' => 'not yet found'
#}
#begin

#buses = WebScraper.new
#stations = buses.busstation
#profile_after['profiles'] = stations[num]
#rescue
#return nil
#end
#profile_after
#end
		def current_page?(path = ' ')
			path_info = request.path_info
			path_info += ' ' if path_info == '/'
			request_path = path_info.split '/'
			request_path[1] == path
		end

       def api_url(resource)
         URI.join(API_BASE_URI, API_VER, resource).to_s
       end

	end

	get '/' do
		haml :home
	end

	get '/station' do
		@num = params[:num].to_i
		if @num
			redirect "/station/#{@num}"
			return nil
		end

	 	haml :station
	end


	get '/station/:num' do
		@num = params[:num].to_i
		@station = HTTParty.get api_url("station/#{@num}.json")
		
		if @num && @station.nil?
			flash[:notice] = 'station number #{num} not found' if @station.nil?
			redirect '/station'
		end
		logger.info "num: #{@station['station']}  name: #{@station['profiles']}"

		haml :station
	end



	# get '/api/v1/station/:station.json' do
	# 	content_type :json
	# 	get_profile(params[:station]).to_json
	# end




#	post '/api/v1/tutorials' do
#		content_type :json
#			begin
#				req = JSON.parse(request.body.read)
#				logger.info req
#			rescue
#			halt 400
#	
#
#			tutorial = Tutorial.new
#			tutorial.num = req['num'].to_json
#			tutorial.station = req['station'].to_json
#			if tutorial.save
#				status 201
#				redirect "/api/v1/tutorials/#{tutorial.id}"
#			end
#	end



#	get '/api/v1/tutorials/:id' do
#	 	content_type :json, 'charset' => 'utf-8'

#	  begin
#		  @tutorial = Tutorial.find(params[:id])
#			num = @tutorial.num
#			station = @tutorial.station
#			result = { num: num, station: station }.to_json
#			logger.info("Found: #{result}")
#			result
#		rescue
#			halt 400
#		end
#	end

get '/tutorials' do
@action = :create
haml :tutorials
end


post '/tutorials' do
request_url = "#{API_BASE_URI}/api/v2/tutorials"
num = params[:num].split("\r\n")
#num=num
station = params[:station].split("\r\n")
params_h = {
num: num,
station: station
}
options = { body: params_h.to_json,
headers: { 'Content-Type' => 'application/json' }
}
result = HTTParty.post(request_url, options)
if (result.code != 200)
flash[:notice] = 'num not found'
redirect '/tutorials'
return nil
end
id = result.request.last_uri.path.split('/').last
session[:result] = result.to_json
session[:num] = num
session[:station] = station
session[:action] = :create
redirect "/tutorials/#{id}"
end
get '/tutorials/:id' do
if session[:action] == :create
session[:action] = nil
@results = JSON.parse(session[:result])
@num = session[:num]
@station = session[:station]
else
request_url = "#{API_BASE_URI}/api/v2/tutorials/#{params[:id]}"
options = { headers: { 'Content-Type' => 'application/json' } }
result = HTTParty.get(request_url, options)
@results = result
end
@id = params[:id]
@action = :update
haml :tutorials
end
delete '/tutorials/:id' do
request_url = "#{API_BASE_URI}/api/v2/tutorials/#{params[:id]}"
result = HTTParty.delete(request_url)
flash[:notice] = 'record of tutorial deleted'
redirect '/tutorials'
end

#end
end

#require 'bundler/setup'
require 'sinatra/base'
require 'busgogo'
require 'json'
require './tutorial'


require 'bundler/setup'
require 'haml'
require 'sinatra/flash'

class Bus < Sinatra::Base
	enable :sessions
	register Sinatra::Flash

		configure :production, :development do
		enable :logging
		end

	helpers do
		def user
			num = params[:num].to_i
			# @station = user
			return nil unless num

			profile_after={
		 		'station' => num,
				'profiles' => 'not yet found'
			}

			begin
				# WebScraper::Scraper.busstation.each do |value|
				# 		profile_after['profiles'].push('station' => value)
				# end
				# profile_after

				buses = WebScraper.new
				stations = buses.busstation
				profile_after['profiles'] = stations[num]
			rescue
				return nil
			end
			profile_after
		end


		def current_page?(path = ' ')
			path_info = request.path_info
			path_info += ' ' if path_info == '/'
			request_path = path_info.split '/'
			request_path[1] == path
		end
	end

	# 	def get_profile(station)
	#        	scmachine = WebScraper.new


	# 			profile_after={
	# 			'station' => station,
	# 			'profiles' => []
	# 			}

	# 			scmachine.busstation.each do |value|
	# 			profile_after['profiles'].push('station' => value)

	# 			end
	# 			profile_after

	# 	end
	# end


	get '/' do
		haml :home
	end

	get '/station' do
		@num = params[:num]
		if @num
			redirect "/station/#{@num}"
			return nil
		end

	 	haml :station
	end


	get '/station/:num' do
		@station = user
		@num = params[:num]
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




	post '/api/v1/tutorials' do
		content_type :json
			begin
				req = JSON.parse(request.body.read)
				logger.info req
			rescue
			halt 400
		#endTables: 0

			tutorial = Tutorial.new
			tutorial.num = req['num'].to_json
			tutorial.station = req['station'].to_json
			if tutorial.save
				status 201
				redirect "/api/v1/tutorials/#{tutorial.id}"
			end
	end



	get '/api/v1/tutorials/:id' do
	 	content_type :json, 'charset' => 'utf-8'

	  begin
		  @tutorial = Tutorial.find(params[:id])
			num = @tutorial.num
			station = @tutorial.station
			result = { num: num, station: station }.to_json
			logger.info("Found: #{result}")
			result
		rescue
			halt 400
		end
	end

end
end

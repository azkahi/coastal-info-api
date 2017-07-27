class CoastalDataController < ApplicationController
	def show
		process_data(params[:station], params[:startdate], params[:enddate], params[:predict])
		response = []
		data = Hash.new
		Dir.chdir "matlab" do
			complete = File.open("Complete.txt", "r")
			predict = File.open("Predict.txt", "r")
			if complete
				uploader = StationDataUploader.new
				uploader.store!(complete)
				data[:complete] = parseCompleteFile(complete)
				File.delete(complete)
			end
			if predict
				data[:predict] = parsePredictFile(predict)
				File.delete(predict)
			end 
			json_response(data)
		end
	end

	def new
		@station = StationDatum.new
	end

	def create
		if (StationDatum.find_by(station: params[:station]) == nil)
			station = StationDatum.new(station: params[:station])
			station.data = params[:data]
			station.save!
		end
	end

	private
		def parseCompleteFile(file)
			i = 1
			ret_arr = []
			file.each do |line|
				if (i >= 17)
					data = Hash.new
					tide, freq, amp, amp_err, pha, pha_err, snr = line.match(/^\s*(\**\w*)\s*(\d+\.*\d*\w*[\+\-]*\d*)\s*(\d+\.*\d*\w*[\+\-]*\d*)\s*(\d+\.*\d*\w*[\+\-]*\d*)\s*(\d+\.*\d*\w*[\+\-]*\d*)\s*(\d+\.*\d*\w*[\+\-]*\d*)\s*(\d+\.*\d*\w*[\+\-]*\d*)$/).captures
					data = { tide: tide, freq: freq.to_f, amp: amp.to_f, pha: pha.to_f, pha_err: pha_err.to_f, snr: snr.to_f }
					ret_arr.push(data)
				end
				i = i + 1
			end
			return ret_arr
		end

		def parsePredictFile(file)
			ret_arr = []
			file.each do |line|
				predict = line.match(/^\s*(\d+\.*\d*\w*[\+\-]*\d*)\s*$/).captures
				ret_arr.push(predict[0].to_f)
			end
			return ret_arr
		end

end

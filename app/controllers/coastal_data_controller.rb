class CoastalDataController < ApplicationController
	def show
		start_date = Date.parse(params[:startdate])
		end_date = Date.parse(params[:enddate])
		prediction = params[:prediction].to_i
		process_data(params[:station], start_date, end_date, prediction)
		response = []
		data = Hash.new
		Dir.chdir "matlab" do
			complete = File.open("Complete.txt", "r")
			predict = File.open("Predict.txt", "r")

			if complete
				data[:complete] = parseCompleteFile(complete)
			end

			if predict
				data[:predict] = parsePredictFile(predict, prediction)
			end

			data[:current] = get_current(params[:station], start_date, end_date)
			json_response(data)
		end
	end

	private
		def parseCompleteFile(file)
			i = 1
			ret_arr = []
			file.each do |line|
				if (i >= 17)
					tide, freq, amp, amp_err, pha, pha_err, snr = line.match(/^\s*\**(\w*)\s*(\d+\.*\d*\w*[\+\-]*\d*)\s*(\d+\.*\d*\w*[\+\-]*\d*)\s*(\d+\.*\d*\w*[\+\-]*\d*)\s*(\d+\.*\d*\w*[\+\-]*\d*)\s*(\d+\.*\d*\w*[\+\-]*\d*)\s*(\d+\.*\d*\w*[\+\-]*\d*)$/).captures
					if ((tide == "K1") || (tide == "O1") || (tide == "M2") || (tide == "S2"))
						data = Hash.new
						data = { tide: tide, amp: amp.to_f }
						ret_arr.push(data)
					end
				end
				i = i + 1
			end
			return ret_arr
		end

		def parsePredictFile(file, prediction)
			ret_arr = []
			file.each do |line|
				predict = line.match(/^\s*(-*\d+\.*\d*\w*[\+\-]*\d*)\s*$/).captures
				ret_arr.push(predict[0].to_f)
			end
			return ret_arr[ret_arr.length - prediction, ret_arr.length]
		end

end

module MatlabInterfacer
	def process_data(station, date_start, date_end, predict)
		parse_raw(station)
		date_end = date_end + predict

		Dir.chdir "matlab" do
			matlabFile = File.new("coastal_info_main.m", "w+")
			if matlabFile
			  matlabFile.puts("timeStart = datenum(#{date_start.year},#{date_start.month},#{date_start.day},0,0,0);")
			  matlabFile.puts("timeEnd = datenum(#{date_end.year},#{date_end.month},#{date_end.day},0,0,0);")
			  matlabFile.puts("Program_Prediksi2015('Data.txt', 'Complete.txt', 'Predict.txt', -2.67, 0.961855493, timeStart, timeEnd);")
			else
			  return "Unable to open file, please try again later."
			end
			matlabFile.close

			system("matlab -nodisplay -nosplash -nojvm < coastal_info_main.m")
		end
		return "OK"
	end

	def parse_raw(station)
		Dir.chdir "matlab/data" do
			if (File.file?(station + '2014.txt'))
				rawFile = File.open(station + "2014.txt", "r")
				
				if rawFile
					inputData = []
					i = 0
					rawFile.each do |line|
						input = Hash.new
						i = i + 1
						puts i
						date, month, year, hour, minute, second, amt = line.match(/^(\d+).(\d+).(\d+)\s*(\d+).(\d+).(\d+)\s*(-*\d+)\s*$/).captures
						input = { date: date.to_i, month: month.to_i, year: year.to_i, hour: hour.to_i, minute: minute.to_i, second: second.to_i, amt: (amt.to_f/100) }
						inputData.push(input)
					end

					Dir.chdir ".." do
						inputFile = File.new("Data.txt", "w+")
						inputData.each do |data|
							inputFile.puts("#{data[:year]}\t#{data[:month]}\t#{data[:date]}\t#{data[:hour]}\t#{data[:minute]}\t#{data[:second]}\t#{data[:amt]}")
						end
					end
				end
			else
				return false
			end
		end
	end

	def get_current(station, date_start, date_end)
		currentData = []
		Dir.chdir "data" do
			if (File.file?(station + '2014.txt'))
				rawFile = File.open(station + "2014.txt", "r")

				if rawFile
					rawFile.each do |line|
						date, hour, amt = line.match(/^(\d+.\d+.\d+)\s*(\d+).\d+.\d+\s*(-*\d+)\s*$/).captures
						rubyDate = Date.parse(date)
						if (rubyDate >= date_start && rubyDate <= date_end)
							input = Hash.new
							input = { date: date, hour: hour.to_i, amt: (amt.to_f/100) }
							currentData.push(input)
						end
					end
				end
			end
		end
		return currentData
	end

end
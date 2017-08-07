module MatlabInterfacer
	def process_data(station, date_start, date_end, predict)
		parse_raw(station)
		msl = get_data_station(station, 'MSL_')
		lat = get_data_station(station, 'LAT_')
		
		puts station
		puts msl
		puts lat
		
		date_end = date_end + predict

		Dir.chdir "matlab" do
			matlabFile = File.new("coastal_info_main.m", "w+")
			if matlabFile
			  matlabFile.puts("timeStart = datenum(#{date_start.year},#{date_start.month},#{date_start.day},0,0,0);")
			  matlabFile.puts("timeEnd = datenum(#{date_end.year},#{date_end.month},#{date_end.day},0,0,0);")
			  matlabFile.puts("Program_Prediksi2015('Data.txt', 'Complete.txt', 'Predict.txt', #{lat}, #{msl}, timeStart, timeEnd);")
			else
			  return "Unable to open file, please try again later."
			end
			matlabFile.close

			system("matlab -nodisplay -nosplash -nojvm < coastal_info_main.m")
		end
		return "OK"
	end

	def get_data_station(station, option)
		out = 0.00

		Dir.chdir "matlab/data" do
			if (File.file?(option + station + ".txt"))
				rawFile = File.open(option + station + ".txt", "r")

				if rawFile
					rawFile.each do |line|
						out = line.to_f
					end
				end
				rawFile.close()
			end
		end
		return out
	end

	def parse_raw(station)
		Dir.chdir "matlab/data" do
			if (File.file?("2014_" + station + ".txt"))
				rawFile = File.open("2014_" + station + ".txt", "r")
				
				if rawFile
					inputData = []
					rawFile.each do |line|
						input = Hash.new
						date, month, year, hour, minute, second, amt = line.match(/^(\d+).(\d+).(\d+)\s*(\d+).(\d+).(\d+)\s*(\S*)\s*$/).captures
						if (amt == 'NaN')
							amt = 'NaN'
						else
							amt = amt.to_f
						end
						input = { year: date.to_i, month: month.to_i, date: year.to_i, hour: hour.to_i, minute: minute.to_i, second: second.to_i, amt: amt }
						inputData.push(input)
					end

					Dir.chdir ".." do
						inputFile = File.new("Data.txt", "w+")
						inputData.each do |data|
							inputFile.puts("#{data[:year]}\t#{data[:month]}\t#{data[:date]}\t#{data[:hour]}\t#{data[:minute]}\t#{data[:second]}\t#{data[:amt]}")
						end
					end
				end
				rawFile.close()
			else
				return false
			end
		end
	end

	def get_current(station, date_start, date_end)
		currentData = []
		Dir.chdir "data" do
			if (File.file?("2014_" + station + ".txt"))
				rawFile = File.open("2014_" + station + ".txt", "r")

				if rawFile
					rawFile.each do |line|
						year, month, day, hour, amt = line.match(/^(\d+).(\d+).(\d+)\s*(\d+).\d+.\d+\s*(\S*)\s*$/).captures
						if (amt == 'NaN')
							amt = nil
						else
							amt = amt.to_f
						end
						
						begin
							rubyDate = Date.new(year.to_i, month.to_i, day.to_i)
							date = "#{day}/#{month}/#{year}"
							if (rubyDate >= date_start && rubyDate <= date_end)
								input = Hash.new
								input = { date: date, hour: hour.to_i, amt: amt }
								currentData.push(input)
							end
						rescue
							puts "Skipping invalid dates"
						end
					end
				end
				rawFile.close()
			end
		end
		return currentData
	end

end
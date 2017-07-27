module MatlabInterfacer
	def process_data(station, startdate, enddate, predict)
		date_start = Date.parse(startdate)
		date_end = Date.parse(enddate)
		if (predict == 'true')
			date_end = date_end + 1
		end
		
		Dir.chdir "matlab" do
			matlabFile = File.new("coastal_info_main.m", "w+")
			puts matlabFile.path
			if matlabFile
			  matlabFile.puts("timeStart = datenum(#{date_start.year},#{date_start.month},#{date_start.day},0,0,0);")
			  matlabFile.puts("timeEnd = datenum(#{date_end.year},#{date_end.month},#{date_end.day},0,0,0);")
			  matlabFile.puts("Data.txt', 'Complete.txt', 'Predict.txt', -2.67, 0.961855493, timeStart, timeEnd);")
			else
			  return "Unable to open file, please try again later."
			end
			matlabFile.close

			system("matlab -nodisplay -nosplash -nojvm < coastal_info_main.m")
		end
		return "OK"
	end
end
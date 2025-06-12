filename = "readings.txt"
io.input( filename )

file_sum, file_cnt_data, file_lines = 0, 0, 0
max_rejected, n_rejected = 0, 0
max_rejected_date, rejected_date = "", ""

for data in io.lines() do
    date = string.match( data, "%d+%-%d+%-%d+" )
    if date == nil then break end
	
    val = {}
    for w in string.gmatch( data, "%s%-*%d+[%.%d]*" ) do
        val[#val+1] = tonumber(w)
    end

    sum, cnt = 0, 0
    for i = 1, #val, 2 do
    	if val[i+1] > 0 then
    	    sum = sum + val[i]
    	    cnt = cnt + 1
    	    n_rejected = 0
    	else
	        if n_rejected == 0 then
	            rejected_date = date
  	        end
    	    n_rejected = n_rejected + 1
    	    if n_rejected > max_rejected then
    	        max_rejected = n_rejected
    	        max_rejected_date = rejected_date
    	    end
    	end
    end

    file_sum = file_sum + sum
    file_cnt_data = file_cnt_data + cnt
    file_lines = file_lines + 1

    print( string.format( "%s:\tRejected: %d\tAccepted: %d\tLine_total: %f\tLine_average: %f", date, #val/2-cnt, cnt, sum, sum/cnt ) )
end

print( string.format( "\nFile:\t  %s", filename ) )
print( string.format( "Total:\t  %f", file_sum ) )
print( string.format( "Readings: %d", file_lines ) )
print( string.format( "Average:  %f", file_sum/file_cnt_data ) )
print( string.format( "Maximum %d consecutive false readings starting at %s.", max_rejected, max_rejected_date ) )

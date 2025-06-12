filename = "mlijobs.txt"

max_out, n_out = 0, 0
occurr_dates = {}

for line in io.lines(filename)
    local dispensed = string.find( line, "OUT" )
    n_out = n_out + (dispensed==true and 1 or -1)
    if dispensed and n_out >= max_out then
       if n_out > max_out then
            max_out = n_out
            occurr_dates = {}
       end
       occurr_dates[#occurr_dates+1] = string.match( line, "@ ([%d+%p]+)" )
    end
end

print( "Maximum licenses in use:", max_out )
print( "Occurrences:" )
for i = 1, #occurr_dates do
    print( "", occurr_dates[i] )
end

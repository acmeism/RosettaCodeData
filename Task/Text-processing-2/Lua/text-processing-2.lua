filename = "readings.txt"
io.input( filename )

dates = {}
duplicated, bad_format = {}, {}
num_good_records, lines_total = 0, 0

while true do
    line = io.read( "*line" )
    if line == nil then break end

    lines_total = lines_total + 1

    date = string.match( line, "%d+%-%d+%-%d+" )
    if dates[date] ~= nil then
        duplicated[#duplicated+1] = date
    end
    dates[date] = 1

    count_pairs, bad_values = 0, false
    for v, w in string.gmatch( line, "%s(%d+[%.%d+]*)%s(%-?%d)" ) do
        count_pairs = count_pairs + 1
        if tonumber(w) <= 0 then
            bad_values = true
        end
    end
    if count_pairs ~= 24 then
        bad_format[#bad_format+1] = date
    end
    if not bad_values then
        num_good_records = num_good_records + 1
    end
end

print( "Lines read:", lines_total )
print( "Valid records: ", num_good_records )
print( "Duplicate dates:" )
for i = 1, #duplicated do
    print( "   ", duplicated[i] )
end
print( "Bad format:" )
for i = 1, #bad_format do
    print( "   ", bad_format[i] )
end

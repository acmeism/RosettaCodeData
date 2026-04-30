--Five Weekend task from Rosetta Code wiki
--User:Lnettnay

include std/datetime.e

atom numbermonths = 0
sequence longmonths = {1, 3, 5, 7, 8, 10, 12}
sequence yearsmonths = {}
atom none = 0
datetime dt

for year = 1900 to 2100 do
	atom flag = 0
	for month = 1 to length(longmonths) do
		dt = new(year, longmonths[month], 1)
		if weeks_day(dt) = 6 then --Friday is day 6
			flag = 1
			numbermonths += 1
			yearsmonths = append(yearsmonths, {year, longmonths[month]})
		end if
	end for

	if flag = 0 then
		none += 1
	end if
end for

puts(1, "Number of months with five full weekends from 1900 to 2100 = ")
? numbermonths

puts(1, "First five and last five years, months\n")

for count = 1 to 5 do
	? yearsmonths[count]
end for

for count = length(yearsmonths) - 4 to length(yearsmonths) do
	? yearsmonths[count]
end for

puts(1, "Number of years that have no months with five full weekends = ")
? none

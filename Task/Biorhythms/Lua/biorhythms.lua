cycles = {"Physical day ", "Emotional day", "Mental day   "}
lengths = {23, 28, 33}
quadrants = {
	{"up and rising", "peak"},
	{"up but falling", "transition"},
	{"down and falling", "valley"},
	{"down but rising", "transition"},
}

function parse_date_string (birthDate)
	local year, month, day = birthDate:match("(%d+)-(%d+)-(%d+)")
	return {year=tonumber(year), month=tonumber(month), day=tonumber(day)}
end

function days_diffeternce (d1, d2)
	if d1.year >= 1970 and d2.year >= 1970 then
		return math.floor(os.difftime(os.time(d2), os.time(d1))/(60*60*24))
	else
		local t1 = math.max (1970-d1.year, 1970-d2.year)
		t1 = math.ceil(t1/4)*4
		d1.year = d1.year + t1
		d2.year = d2.year + t1
		return math.floor(os.difftime(os.time(d2), os.time(d1))/(60*60*24))
	end
end

function biorhythms (birthDate, targetDate)
	local bd = parse_date_string(birthDate)
	local td = parse_date_string(targetDate)
	local days = days_diffeternce (bd, td)

	print('Born: '.. birthDate .. ', Target: ' .. targetDate)
	print("Day: ", days)
	for i=1, #lengths do
		local len = lengths[i]
		local posn = days%len
		local quadrant = math.floor(posn/len*4)+1
		local percent  = math.floor(math.sin(2*math.pi*posn/len)*1000)/10
		local cycle = cycles[i]
		local desc = percent > 95 and "peak" or
			percent < -95 and "valley" or
			math.abs(percent) < 5 and "critical transition" or "other"
		if desc == "other" then
			local t = math.floor(quadrant/4*len)-posn
			local qtrend, qnext = quadrants[quadrant][1], quadrants[quadrant][2]
			desc = percent .. '% (' .. qtrend .. ', next transition in ' .. t ..' days)'
		end
		print(cycle, posn..'/'..len, ': '.. desc)
	end
	print(' ')
end

datePairs = {
	{"1943-03-09", "1972-07-11"},
	{"1809-01-12", "1863-11-19"},
	{"1809-02-12", "1863-11-19"},
	{"2021-02-25", "2022-04-18"},
}

for i=1, #datePairs do
	biorhythms(datePairs[i][1], datePairs[i][2])
end

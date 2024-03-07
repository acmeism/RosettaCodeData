local year = 2020
for i=1, 15 do
	local dateS
	repeat
		year = year+1
		local yearS = tostring(year)
		local monthS, dayS = yearS:reverse():match"^(%d%d)(%d%d)$"
		local monthN, dayN = tonumber(monthS), tonumber(dayS)
		dateS = yearS.."-"..monthS.."-"..dayS
	until
		monthN>0 and monthN<=12 -- real month
		and dayN<32 -- possible day
		and os.date( -- real date check
	-- be aware that this check is unnecessary because it only affects the 13th century
			"%Y-%m-%d"
			,os.time{
				year = year
				,month = monthN
				,day = dayN
			}
		) == dateS
	print(dateS)
end

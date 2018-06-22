local times = {"23:00:17","23:40:20","00:12:45","00:17:19"}

-- returns time converted to a radian format
local function timeToAngle(str)
	local h,m,s = str:match("(..):(..):(..)")
	return (h + m / 60 + s / 3600)/12 * math.pi
end

-- computes the mean of the angles inside a list
local function meanAngle(angles)
	local sumSin,sumCos = 0,0
	for k,v in pairs(angles) do
		sumSin = sumSin + math.sin(v)
		sumCos = sumCos + math.cos(v)
	end
	return math.atan2(sumSin,sumCos)
end

-- converts and angle back to a time string
local function angleToTime(angle)
	local abs = angle % (math.pi * 2)
	local time = abs / math.pi * 12
	local h = math.floor(time)
	local m = math.floor(time * 60) % 60
	local s = math.floor(time * 3600) % 60
	return string.format("%02d:%02d:%02d", h, m, s)
end

-- convert times to angles
for k,v in pairs(times) do
	times[k] = timeToAngle(v)
end

print(angleToTime(meanAngle(times)))

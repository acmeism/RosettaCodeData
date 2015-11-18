function meanAngle (angleList)
	local sumSin, sumCos = 0, 0
	for i, angle in pairs(angleList) do
		sumSin = sumSin + math.sin(math.rad(angle))
		sumCos = sumCos + math.cos(math.rad(angle))
	end
	local result = math.deg(math.atan2(sumSin, sumCos))
	return string.format("%.2f", result)
end

print(meanAngle({350, 10}))
print(meanAngle({90, 180, 270, 360}))
print(meanAngle({10, 20, 30}))

bearing = {degrees = 0} -- prototype object

function bearing:assign(angle)
	angle = tonumber(angle) or 0
	while angle > 180 do
		angle = angle - 360
	end
	while angle < -180 do
		angle = angle + 360
	end
	self.degrees = angle
end

function bearing:new(size)
	local child_object = {}
	setmetatable(child_object, {__index = self})
	child_object:assign(size)
	return child_object
end

function bearing:subtract(other)
	local difference = self.degrees - other.degrees
	return self:new(difference)
end

function bearing:list(sizes)
	local bearings = {}
	for index, size in ipairs(sizes) do
		table.insert(bearings, self:new(size))
	end
	return bearings
end

function bearing:text()
	return string.format("%.4f deg", self.degrees)
end

function main()
	local subtrahends = bearing:list{
		20, -45, -85, -95, -45, -45, 29.4803, -78.3251,
		-70099.74233810938, -165313.6666297357,
		1174.8380510598456, 60175.77306795546
	}
	local minuends = bearing:list{
		45, 45, 90, 90, 125, 145, -88.6381, -159.036,
		29840.67437876723, 33693.9894517456,
		-154146.66490124757, 42213.07192354373
	}
	for index = 1, #minuends do
		local b2, b1 = minuends[index], subtrahends[index]
		local b3 = b2:subtract(b1)
		local statement = string.format(
			"%s - %s = %s\n",
			b2:text(), b1:text(), b3:text()
		)
		io.write(statement)
	end
end

main()

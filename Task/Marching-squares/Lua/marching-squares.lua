-- positive directions: right, down, clockwise
local Directions = { -- clockwise from North
	N  = {x= 0, y=-1},
	E  = {x= 1, y= 0},
	S  = {x= 0, y= 1},
	W  = {x=-1, y= 0},
}

local dxdybList = {
	{0,0,1}, -- same position
	{1,0,2}, -- right
	{0,1,4}, -- down
	{1,1,8}, -- right and down
}

local cases = {
 "W", "N", "W", "S",
 "S", nil, "S", "E",
 nil, "N", "W", "E",
 "E", "N",
}

local function identifyPerimeter(iLayer, startingX, startingY, data)
	local resultDirections = {}
	local resultPositions = {}
	local currentX, currentY = startingX, startingY
	local direction, prevDirection
	while true do
		local mask = 0
		for _, d in ipairs (dxdybList) do
			local dx, dy, b = d[1], d[2], d[3]
			local mx, my = currentX+dx, currentY+dy
			if mx>1 and my>1
				and  data[my-1] and  data[my-1][mx-1]
				and data[my-1][mx-1] == iLayer then
				mask = mask + b
			end
		end
		direction = cases[mask]		
		if not direction then
			if mask == 6 then
				direction = (prevDirection == "E") and "N" or "S"
			elseif mask == 9 then
				direction = (prevDirection == "S") and "E" or "W"
				
			else
				error ('no mask: '.. mask..' by x:'..currentX..' y:'..currentY, 1)
			end
		end
		table.insert (resultDirections, direction)
		table.insert (resultPositions, currentX)
		table.insert (resultPositions, currentY)
		local vDir = Directions[direction]
		currentX, currentY = currentX+vDir.x, currentY+vDir.y
		prevDirection = direction
		if startingX == currentX and startingY == currentY then
			return resultDirections, resultPositions
		end
	end
end

local function findFirstOnLayer (iLayer, data)
	for y = 1, #data do -- from 1 to hight
		for x = 1, #data[1] do -- from 1 to width
			local value = data[y][x]
			if value == iLayer then
				return x, y -- only one contour
			end
		end
	end
end

local function msMain (iLayer, data)
	local rootX, rootY = findFirstOnLayer (iLayer, data)
	print ("root: x="..rootX..' y='..rootY)
	local directions, positions = identifyPerimeter(iLayer, rootX, rootY, data)
	print ('directions amount: '..#directions)
	print ('directions: '.. table.concat (directions, ','))
	
	local strPositions = ""
	for i = 1, #positions-1, 2 do
		strPositions = strPositions..positions[i]..','..positions[i+1]..', '
	end
	print ('positions: {' .. strPositions..'}')
end

local example = {
	{0, 0, 0, 0, 0, 0},
	{1, 0, 0, 0, 0, 1},
	{0, 1, 1, 0, 1, 0},
	{0, 1, 1, 1, 1, 0},
	{0, 1, 0, 1, 1, 0},
	{1, 0, 0, 0, 0, 1},
}

msMain (1, example)

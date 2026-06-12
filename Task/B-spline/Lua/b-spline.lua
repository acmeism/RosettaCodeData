local function Range(from, to)
	local range = {}
	for n = from, to do  table.insert(range, n)  end
	return range
end

local function Bspline(controlPoints, k)
	return {
		controlPoints = controlPoints,
		n = #controlPoints,
		k = k,
		t = Range(1, #controlPoints+k), -- Use a uniform knot vector, delta=1.
	}
end

local function helper(bspline, i, k, x)
	return (bspline.t[i+k] ~= bspline.t[i])
	   and (x - bspline.t[i]) / (bspline.t[i+k] - bspline.t[i])
	   or  0
end

local function calculateBspline(bspline, i, k, x)
	if k == 1 then
		return (bspline.t[i] <= x and x < bspline.t[i+1]) and 1 or 0
	end
	return (  helper(bspline, i  , k-1, x)) * calculateBspline(bspline, i  , k-1, x)
	     + (1-helper(bspline, i+1, k-1, x)) * calculateBspline(bspline, i+1, k-1, x)
end

local function round(n)
	return math.floor(n+.5)
end

local function getBsplinePoints(bspline)
	local points = {}

	for x = bspline.t[bspline.k], bspline.t[bspline.n+1]-1 do
		local sumX = 0
		local sumY = 0

		for i = 1, bspline.n do
			local f = calculateBspline(bspline, i, bspline.k, x)
			sumX    = sumX + f * bspline.controlPoints[i].x
			sumY    = sumY + f * bspline.controlPoints[i].y
		end
		table.insert(points, {x=round(sumX), y=round(sumY)})
	end

	return points
end

local function Plot(unscaledWidth,unscaledHeight, scaleX,scaleY)
	local plot = {
		width  = round(unscaledWidth  * scaleX),
		height = round(unscaledHeight * scaleY),
		scaleX = scaleX,
		scaleY = scaleY,
	}
	for row = 1, plot.height do
		plot[row] = {}
	end
	return plot
end

local function raytrace(x,y, x2,y2, visit)
	local dx   = math.abs(x2 - x)
	local dy   = math.abs(y2 - y)
	local n    = 1 + dx + dy
	local dirX = (x2 > x) and 1 or -1
	local dirY = (y2 > y) and 1 or -1
	local err  = dx - dy
	dx, dy     = 2*dx, 2*dy

	for n = 1, n do
		visit(x, y)
		if err > 0 then  x, err = x+dirX, err-dy
		else             y, err = y+dirY, err+dx  end
	end
end

local function plotLine(plot, x1,y1, x2,y2)
	raytrace(x1,y1, x2,y2, function(x, y)
		if x >= 0 and y >= 0 and x < plot.width and y < plot.height then
			plot[y+1][x+1] = true
		end
	end)
end

local function plotBspline(bspline, plot)
	if bspline.k > bspline.n or bspline.k < 1 then
		error("k (= "..bspline.k..") can't be more than "..bspline.n.." or less than 1.")
	end
	local points = getBsplinePoints(bspline)

	-- Plot the curve.
	for i = 1, #points-1 do
		local p1 = points[i]
		local p2 = points[i+1]
		plotLine(plot,
			round(p1.x*plot.scaleX), round(p1.y*plot.scaleY),
			round(p2.x*plot.scaleX), round(p2.y*plot.scaleY)
		)
	end
end

local function printPlot(plot)
	for row = 1, plot.height do
		for column = 1, plot.width do
			io.write(plot[row][column] and "@" or " ")
		end
		io.write("\n")
	end
end

local controlPoints = {
	{x=171, y=171}, {x=185, y=111}, {x=202, y=109}, {x=202, y=189}, {x=328, y=160}, {x=208, y=254},
	{x=241, y=330}, {x=164, y=252}, {x= 69, y=278}, {x=139, y=208}, {x= 72, y=148}, {x=168, y=172},
}
local k       = 4 -- Polynomial degree is one less than this i.e. cubic.
local bspline = Bspline(controlPoints, k)

local scaleX = .4 -- Since we print the plot to the console as text let's scale things appropriately.
local scaleY = .2
local plot   = Plot(350,350, scaleX,scaleY)
plotBspline(bspline, plot)

printPlot(plot)

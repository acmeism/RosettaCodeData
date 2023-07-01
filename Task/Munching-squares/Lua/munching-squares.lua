local clr =  {}
function drawMSquares()
	local points = {}
	for y = 0, hei-1 do
		for x = 0, wid-1 do
			local idx = bit.bxor(x, y)%256
			local r, g, b = clr[idx][1], clr[idx][2], clr[idx][3]
			local point = {x+1, y+1, r/255, g/255, b/255, 1}
			table.insert (points, point)
		end
	end
	love.graphics.points(points)
end

function createPalette()
	for i = 0, 255 do
		clr[i] = {i*2.8%256, i*3.2%256, i*1.5%256}
	end
end

function love.load()
	wid, hei = 256, 256
	love.window.setMode(wid, hei)
	canvas = love.graphics.newCanvas()
	love.graphics.setCanvas(canvas)
		createPalette()
		drawMSquares()
	love.graphics.setCanvas()
end

function love.draw()
	love.graphics.setColor(1,1,1)
	love.graphics.draw(canvas)
end

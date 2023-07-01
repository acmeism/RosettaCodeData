UP, RIGHT, DOWN, LEFT = 1, 2, 3, 4
UpdateTime=0.200
Timer = 0
GridSize = 30
GridWidth, GridHeight = 20, 10

local directions = {
	[UP] = 	  {x= 0, y=-1},
	[RIGHT] = {x= 1, y= 0},
	[DOWN] =  {x= 0, y= 1},
	[LEFT] =  {x=-1, y= 0},
}

local function isPositionInBody(x, y)
	for i = 1, #Body-3, 2 do -- skip tail, it moves before we get in
		if x == Body[i] and y == Body[i+1] then
			return true
		end
	end
	return false
end

local function isPositionInApple(x, y)
	if x == Apple.x and y == Apple.y then
		return true
	end
	return false
end

local function newApple ()
	local ApplePlaced = false
	while not ApplePlaced do
		local x = GridSize*math.random (GridWidth)
		local y = GridSize*math.random (GridHeight)
		if not isPositionInBody(x, y) then
			Apple = {x=x, y=y}
			ApplePlaced = true
		end
	end
end

local function newGame ()
	Score = 0
	GameOver = false
	local x = GridSize*math.floor(math.random (0.25*GridWidth, 0.75*GridWidth))
	print (x)
	local y = GridSize*math.floor(math.random (0.25*GridHeight, 0.75*GridHeight))
	print (y)
	local iDirection = math.random(4)
	local d = directions[iDirection]
	Head = {
		x=x,
		y=y,
		iDirection = iDirection,
		nextDirection = iDirection,
	}
	Body = {x, y, x-GridSize*d.x, y-GridSize*d.y}
	Apples = {}
	newApple ()
end

function love.load()
	newGame ()
end

local function moveSnake (x, y, iDirection, longer)
	table.insert (Body, 1, x)
	table.insert (Body, 2, y)
	Head.x = x
	Head.y = y
	Head.iDirection = iDirection
	if not longer then
		-- remove last pair
		table.remove(Body)
		table.remove(Body)
	end
	if  x <= 0 or x > GridSize*(GridWidth) or
		y <= 0 or y > GridSize*(GridHeight) then
		GameOver = true
	end
end

function love.update(dt)
	Timer = Timer + dt
	if Timer < UpdateTime then return end
	Timer = Timer - UpdateTime

	local iDirection = Head.nextDirection
	local d = directions[iDirection]
	local x, y = Head.x+GridSize*d.x, Head.y+GridSize*d.y
	if isPositionInBody(x, y) then
		GameOver = true
	elseif isPositionInApple(x, y) then
		Score = Score + 1
		newApple ()
		moveSnake (x, y, iDirection, true)
	else
		moveSnake (x, y, iDirection, false)
	end
end

function drawHead () -- position, length, width and angle
	love.graphics.push()
	love.graphics.translate(Head.x, Head.y)
	love.graphics.rotate((Head.iDirection-2)*math.pi/2)
	love.graphics.polygon("fill",
		-GridSize/3, -GridSize /3,
		-GridSize/3,  GridSize /3,
		 GridSize/3, 0)
	love.graphics.pop()
end

function love.draw()
	love.graphics.setColor(0,1,0)
	love.graphics.print ('Score: '..tostring(Score), 10, 10)
	if GameOver then
		love.graphics.print ('Game Over: '..tostring(GameOver)..'. Press "Space" to continue', 10, 30)
	else
		love.graphics.translate(GridSize, GridSize)
		love.graphics.setColor(0.6,0.6,0.6)
		love.graphics.setLineWidth(0.25)
		for x = GridSize, GridSize*GridWidth, GridSize do
			love.graphics.line (x, GridSize, x, GridSize*GridHeight)
		end
		for y = GridSize, GridSize*GridHeight, GridSize do
			love.graphics.line (GridSize, y, GridSize*GridWidth, y)
		end
		love.graphics.setLineWidth((GridSize/4)+0.5)
		love.graphics.setColor(1,1,1)
		love.graphics.line (Body)
		drawHead ()
		love.graphics.setColor(1,0,0)
		love.graphics.circle ('fill', Apple.x, Apple.y, GridSize/4)
	end
end

function love.keypressed(key, scancode, isrepeat)
	if false then
	elseif key == "space" then
		if GameOver then
			GameOver = false
			newGame ()
		end
	elseif key == "escape" then
		love.event.quit()
	else
		local iDirection = Head.iDirection
		if iDirection == UP or
			iDirection == DOWN then
			local right = love.keyboard.isScancodeDown ("d")
			local left = love.keyboard.isScancodeDown ("a")
			if right and not left then
				iDirection = RIGHT
			elseif left and not right then
				iDirection = LEFT
			end
		else -- right or left
			local down = love.keyboard.isScancodeDown ("s")
			local up = love.keyboard.isScancodeDown ("w")
			if up and not down then
				iDirection = UP
			elseif down and not up then
				iDirection = DOWN
			end
		end
		Head.nextDirection = iDirection
	end
end

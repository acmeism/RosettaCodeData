function love.load()
	text = "Hello World! "
	length = string.len(text)
	
	
	update_time = 0.3
	timer = 0
	right_direction = true
	
	
	local width, height = love.graphics.getDimensions( )

	local size = 100
	local font = love.graphics.setNewFont( size )
	local twidth = font:getWidth( text )
	local theight = font:getHeight( )
	x = width/2 - twidth/2
	y = height/2-theight/2
	
end


function love.update(dt)
	timer = timer + dt
	if timer > update_time then
		timer = timer - update_time
		if right_direction then
			text = string.sub(text, 2, length) .. string.sub(text, 1, 1)
		else
			text = string.sub(text, length, length) .. string.sub(text, 1, length-1)
		end
	end
end


function love.draw()
	love.graphics.print (text, x, y)
end

function love.keypressed(key, scancode, isrepeat)
	if false then
	elseif key == "escape" then
		love.event.quit()
	end
end

function love.mousepressed( x, y, button, istouch, presses )
	right_direction = not right_direction
end

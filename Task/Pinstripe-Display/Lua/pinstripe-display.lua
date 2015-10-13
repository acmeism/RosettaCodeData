function love.load()	
    WIDTH = love.window.getWidth()
    ROW_HEIGHT = math.floor(love.window.getHeight()/4)
    love.graphics.setBackgroundColor({0,0,0})
    love.graphics.setLineWidth(1)
    love.graphics.setLineStyle("rough")
end

function love.draw()
    for j = 0, 3 do
        for i = 0, WIDTH, (j+1)*2 do
	    love.graphics.setColor({255,255,255})
	    for h = 0, j do
		love.graphics.line(i+h, j*ROW_HEIGHT, i+h, (j+1)*ROW_HEIGHT)
	    end
	end
    end
end

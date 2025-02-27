function love.load ()
    love.window.setTitle("Polyspiral")
    incr = 0
end

function love.update (dt)
    incr = (incr + 0.05 * dt) % 360
    x1 = love.graphics.getWidth() / 2
    y1 = love.graphics.getHeight() / 2
    length = 5
    angle = incr
end

function love.draw ()
    for i = 1, 150 do
        x2 = x1 + math.cos(angle) * length
        y2 = y1 + math.sin(angle) * length
        love.graphics.line(x1, y1, x2, y2)
        x1, y1 = x2, y2
        length = length + 3
        angle = (angle + incr) % 360
    end
end

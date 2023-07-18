-- Returns canvas of given width and height containing a circle
function initCanvas (width, height)
    local c = love.graphics.newCanvas(width, height)
    love.graphics.setCanvas(c) -- Switch to drawing on canvas 'c'
    love.graphics.circle("fill", width / 2, height / 2, 2, 100)
    love.graphics.setCanvas() -- Switch back to drawing on main screen
    return c
end

-- Returns particle system with given canvas
function initPartSys (image, maxParticles)
    local ps = love.graphics.newParticleSystem(image, maxParticles)
    ps:setParticleLifetime(3, 5) -- (min, max)
    ps:setDirection(math.pi * 1.5)
    ps:setSpeed(700)
    ps:setLinearAcceleration(-100, 500, 100, 700) -- (minX, minY, maxX, maxY)
    ps:setEmissionRate(1000)
    ps:setPosition(400, 550)
    ps:setColors(1, 1, 1, 1, 0, 0, 1, 0) -- Start solid white, fade to transluscent blue
    return ps
end

-- LÖVE callback that runs on program start
function love.load ()
    love.window.setTitle("Lua particle fountain")
    local canvas = initCanvas(10, 10)
    psystem = initPartSys(canvas, 10000)
end

-- LÖVE callback to update values before each frame
function love.update (dt)
    psystem:update(dt)
end

-- LÖVE callback to draw each frame to the screen
function love.draw ()
    love.graphics.draw(psystem)
end

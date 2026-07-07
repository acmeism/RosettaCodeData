-- Import the custom constant table module
local const = require("const")

-- Converts HSV (Hue, Saturation, Value) colour values to RGB (Red, Green, Blue).
--
-- Args:
--     h (number): Hue (0.0 to 1.0)
--     s (number): Saturation (0.0 to 1.0)
--     v (number): Value/Brightness (0.0 to 1.0)
--
-- Returns:
--     number, number, number
--     The corresponding R, G, and B values (0.0 to 1.0)
local function hsvToRGB(h, s, v)
    -- If saturation is 0 or less, the colour is a shade of gray
    if s <= 0 then
        return v, v, v
    end

    -- Scale hue to 0-6 range for sector calculation
    h = h * 6
    local c = v * s  -- Chroma
    local x = (1 - math.abs((h%2) - 1)) * c  -- Secondary value
    local m, r, g, b = (v - c), 0, 0, 0  -- Base offset and initial RGB values

    -- Determine RGB based on the hue sector (0 to 6)
    if h < 1 then
        r, g, b = c, x, 0
    elseif h < 2 then
        r, g, b = x, c, 0
    elseif h < 3 then
        r, g, b = 0, c, x
    elseif h < 4 then
        r, g, b = 0, x, c
    elseif h < 5 then
        r, g, b = x, 0, c
    else
        r, g, b = c, 0, x
    end

    -- Add the base offset (m) to shift the values to the correct brightness
    return r + m, g + m, b + m
end

-- Define simulation and rendering constants
local C = const.makeConstantTable({
    -- Lorenz system parameters (classic chaotic values)
    SIGMA = 10,
    RHO = 28,
    BETA = 8 / 3,

    -- Rendering settings
    OFFSET_X = 1024 / 2,      -- Centre X coordinate on screen
    OFFSET_Y = 768 / 2,       -- Centre Y coordinate on screen
    SCALE = 10,               -- Multiplier to scale math coordinates to screen pixels
    MATH_DT = 0.01,           -- Time step for the Euler integration
    STEPS_PER_FRAME = 2 ^ 5,  -- Number of math calculations per drawn frame (32)
    Z_MAX = 53                -- Maximum expected Z value for colour normalisation
})

-- Initialise the starting point for the Lorenz attractor
-- (Slightly off-origin to prevent the math from stalling at 0,0,0)
local x, y, z = 0.01, 0, 0

-- Variables for rendering
local trailCanvas     -- Offscreen canvas to draw the fading trails
local prevSX, prevSY  -- Previous screen coordinates to draw continuous lines
local time = 0        -- Tracks elapsed time for the reset loop
local duration = 10   -- How long (in seconds) before the screen clears and resets

-- LÖVE callback: Runs once when the game starts
function love.load()
    -- Set window resolution and title
    love.window.setMode(1024, 768)
    love.window.setTitle("Lorenz attractor")

    -- Create an offscreen canvas matching the window size
    trailCanvas = love.graphics.newCanvas(1024, 768)
    -- Use smooth lines for better visual quality
    love.graphics.setLineStyle("smooth")
end

-- LÖVE callback: Runs every frame to update logic and draw to the canvas
function love.update(dt)
    -- Redirect all drawing operations to the offscreen canvas
    love.graphics.setCanvas(trailCanvas)

    -- Draw a very transparent black rectangle over the entire canvas.
    -- This creates the "fading trail" effect instead of clearing the screen completely.
    love.graphics.setColor(0, 0, 0, 1/(2^5))
    love.graphics.rectangle("fill", 0, 0, 1024, 768)

    -- Perform multiple math steps per frame to draw a smoother, faster line
    for _ = 1, C.STEPS_PER_FRAME do
        -- Calculate derivatives using the Lorenz differential equations
        local dx = C.SIGMA * (y - x) * C.MATH_DT
        local dy = (x * (C.RHO - z) - y) * C.MATH_DT
        local dz = (x * y - C.BETA * z) * C.MATH_DT

        -- Update the 3D coordinates using Euler's method
        x = x + dx
        y = y + dy
        z = z + dz

        -- Project 3D coordinates to 2D screen space
        -- (ignoring Z for position, used for colour later)
        sx = x * C.SCALE + C.OFFSET_X
        sy = y * C.SCALE + C.OFFSET_Y

        -- Draw a line from the previous point to the current point
        if prevSX then
            -- Normalise the Z coordinate between 0 and 1 for the color gradient
            local zNorm = math.max(0, math.min(1, z/C.Z_MAX))
            -- Set colour based on Z height
            love.graphics.setColor(hsvToRGB(zNorm, 1, 1))
            -- Draw the line segment
            love.graphics.line(prevSX, prevSY, sx, sy)
        end

        -- Store current screen coordinates for the next iteration
        prevSX, prevSY = sx, sy
    end

    -- Check if the animation cycle is complete
    if time >= duration then
        -- Clear the canvas completely to start fresh and reset the timer
        love.graphics.clear()
        time = 0
    end

    -- Reset drawing target back to the main screen
    love.graphics.setCanvas()

    -- Increment the global time tracker by the delta time (frame time)
    time = time + dt
end

-- LÖVE callback: Runs every frame to draw to the actual screen
function love.draw()
    -- Draw the offscreen canvas (which contains our attractor trails) to the screen
    love.graphics.draw(trailCanvas)
end

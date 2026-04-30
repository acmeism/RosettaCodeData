-- Import the Moses functional programming library
-- (provides map, min, max, include, etc.)
local moses = require("moses")

-- Helper: checks if any value in a table is truthy (i.e., not nil/false)
-- Used to test if a point lies inside *any* of the circles.
local function any(t)
    return moses.include(t, function(v)
        return v and true  -- returns true as soon as one truthy element is found
    end)
end

-- Factory function to create a circle object with centre `(x, y)` and radius `r`
local function newCircle(x, y, radius)
    local c = {
        x = x,      -- x-coordinate of centre
        y = y,      -- y-coordinate of centre
        r = radius  -- radius
    }
    return c
end

-- Define a fixed set of 25 circles
local circles = {
    newCircle( 1.6417233788,  1.6121789534, 0.0848270516),
    newCircle(-1.4944608174,  1.2077959613, 1.1039549836),
    newCircle( 0.6110294452, -0.6907087527, 0.9089162485),
    newCircle( 0.3844862411,  0.2923344616, 0.2375743054),
    newCircle(-0.2495892950, -0.3832854473, 1.0845181219),
    newCircle( 1.7813504266,  1.6178237031, 0.8162655711),
    newCircle(-0.1985249206, -0.8343333301, 0.0538864941),
    newCircle(-1.7011985145, -0.1263820964, 0.4776976918),
    newCircle(-0.4319462812,  1.4104420482, 0.7886291537),
    newCircle( 0.2178372997, -0.9499557344, 0.0357871187),
    newCircle(-0.6294854565, -1.3078893852, 0.7653357688),
    newCircle( 1.7952608455,  0.6281269104, 0.2727652452),
    newCircle( 1.4168575317,  1.0683357171, 1.1016025378),
    newCircle( 1.4637371396,  0.9463877418, 1.1846214562),
    newCircle(-0.5263668798,  1.7315156631, 1.4428514068),
    newCircle(-1.2197352481,  0.9144146579, 1.0727263474),
    newCircle(-0.1389358881,  0.1092805780, 0.7350208828),
    newCircle( 1.5293954595,  0.0030278255, 1.2472867347),
    newCircle(-0.5258728625,  1.3782633069, 1.3495508831),
    newCircle(-0.1403562064,  0.2437382535, 1.3804956588),
    newCircle( 0.8055826339, -0.0482092025, 0.3327165165),
    newCircle(-0.6311979224,  0.7184578971, 0.2491045282),
    newCircle( 1.4685857879, -0.8347049536, 1.3670667538),
    newCircle(-0.6855727502,  1.6465021616, 1.0593087096),
    newCircle( 0.0152957411,  0.0638919221, 0.9771215985)
}

-- Compute the axis-aligned bounding box that contains all circles
local xMin = moses.min(moses.map(circles, function(c)
    return c.x - c.r  -- leftmost point
end))
local xMax = moses.max(moses.map(circles, function(c)
    return c.x + c.r  -- rightmost point
end))
local yMin = moses.min(moses.map(circles, function(c)
    return c.y - c.r  -- bottommost point
end))
local yMax = moses.max(moses.map(circles, function(c)
    return c.y + c.r  -- topmost point
end))

-- Resolution of the grid: use a 500×500 pixel-like grid over the bounding box
local boxSide = 500

-- Width and height of each grid cell (pixel)
local dx = (xMax - xMin) / boxSide
local dy = (yMax - yMin) / boxSide

-- Count how many grid cells contain at least one point inside the union of circles
local count = 0

-- Iterate over each row (y-direction)
for r = 1, boxSide do
    -- Compute y-coordinate at the *centre* of the current row's cell

    -- Note: using `r * dy` places sample at top edge + dy, ...,
    -- effectively sampling centres if we consider [0,1] indexing

    -- (More precisely: samples at yMin + dy, yMin + 2*dx, ..., yMin + boxSide*dx = yMax)
    local y = yMin + r * dy

    -- Iterate over each column (x-direction)
    for c = 1, boxSide do
        -- Compute x-coordinate at the centre of the current column's cell
        local x = xMin + c * dx

        -- Check if the point (x, y) lies inside *any* circle:
        -- For each circle, compute squared distance from (x,y) to centre
        -- and compare to squared radius (to avoid `sqrt` for performance)
        if any(moses.map(circles, function(circle)
            return (x - circle.x) ^ 2 + (y - circle.y) ^ 2 <= circle.r ^ 2
        end)) then
            -- If inside at least one circle, count this grid cell
            count = count + 1
        end
    end
end

-- Approximate area = (number of covered cells) × (area per cell)
-- This is a standard Monte Carlo / grid-based area estimation technique
print("Approximated area: "..(count*dx*dy))

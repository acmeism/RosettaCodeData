-- Import the Moses functional programming library for utilities like map, select,
-- range, etc.
local moses = require("moses")

-- Helper function to create a circle object with centre `(x, y)` and radius `r`
local function newCircle(x, y, radius)
    local c = {
        x = x,      -- x-coordinate of the circle's centre
        y = y,      -- y-coordinate of the circle's centre
        r = radius  -- radius of the circle
    }
    return c
end

-- Define a list of 25 circles with precomputed coordinates and radii.
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

-- Approximate the total area covered by the union of all circles using horizontal
-- scanlines.

-- Arguments:
--   `precision`: vertical step size (smaller = more accurate but slower)
--   `c`: table of circle objects `{x, y, r}`
local function areaScan(precision, c)
    -- For a given circle and horizontal line at height `y`,
    -- compute the x-interval [left, right] where the line intersects the circle.
    -- Returns a table {x = left, y = right}
    -- (note: 'y' here is actually the right x-bound!)
    local function section(c_, y)
        -- Half-width of the chord at height y (using Pythagoras: r^2 = dx^2 + dy^2)
        local dr = math.sqrt(c_.r^2-(y-c_.y)^2)
        return {x = c_.x - dr, y = c_.x + dr}  -- left and right x-coordinates
    end

    -- Collect all top (y + r) and bottom (y - r) edges of circles to find vertical bounds
    local ys = moses.map(c, function(v)
        return v.y + v.r  -- top edge of each circle
    end)
    ys = moses.append(ys, moses.map(c, function(v)
        return v.y - v.r  -- bottom edge of each circle
    end))

    -- Determine the discrete scanline range:
    -- Convert min/max y-values into integer indices scaled by `precision`
    -- (Use `table.unpack` for Lua 5.2+; use `unpack` for LuaJIT --
    -- see commented alternatives)
    local mins = math.floor(math.min(table.unpack(ys))/precision)  -- comment this line first to run on LuaJIT
    -- local mins = math.floor(math.min(unpack(ys)) / precision)  -- uncomment this line to run on LuaJIT
    local maxs = math.ceil(math.max(table.unpack(ys))/precision)   -- comment this line first to run on LuaJIT
    -- local maxs = math.ceil(math.max(unpack(ys)) / precision)   -- uncomment this line to run on LuaJIT

    local total = 0  -- Accumulates total horizontal length across all scanlines

    -- Generate actual y-coordinates for each scanline
    local coords = moses.map(moses.range(mins, maxs+1), function(x)
        return precision * x
    end)

    -- Sweep horizontally across each scanline
    for _, y in ipairs(coords) do
        local right = -math.huge  -- Tracks the rightmost `x` covered so far in this scanline

        -- Step 1: Select only circles that intersect the current horizontal line at y
        local intervals = moses.select(c, function(c_)
            return math.abs(y-c_.y) < c_.r  -- true if `|dy| < radius` → intersection exists
        end)

        -- Step 2: Convert each intersecting circle into its x-interval (chord)
        intervals = moses.map(intervals, function(c_)
            return section(c_, y)
        end)

        -- Step 3: Sort intervals by their left endpoint (x)
        table.sort(intervals, function(c1, c2)
            return c1.x < c2.x
        end)

        -- Step 4: Merge overlapping intervals and accumulate total covered width
        for _, interval in ipairs(intervals) do
            -- Only add the portion of the interval not already covered
            if interval.y > right then
                -- Add uncovered segment: from `max(left, previous_right`) to `current_right`
                total = total + interval.y - math.max(interval.x, right)
                right = interval.y  -- update the rightmost covered x
            end
        end
    end

    -- Multiply total horizontal length by vertical step size to get approximate area
    return total * precision
end

-- Compute and print the approximate union area of all circles with high precision (1e-5)
print("Approximate area: "..areaScan(1e-5, circles))

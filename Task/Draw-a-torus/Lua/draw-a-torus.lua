-- Utility function to round a number to a specific number of decimal places
local function round(num, places)
    local mult = 10 ^ (places or 0)
    return math.floor(num*mult+0.5)/mult
end

-- Screen dimensions
local width, height = 800, 600
-- Torus geometry: distance from centre to tube centre, and tube radius
local outerRadius, innerRadius = 150, 60
-- Rotation angles for the torus (fixed for this static render)
local rotA, rotB = 0.5, 0.5

-- Pre-calculate sine and cosine for rotation matrices to save computation in loops
local sinA = math.sin(rotA)
local cosA = math.cos(rotA)
local sinB = math.sin(rotB)
local cosB = math.cos(rotB)

-- Global variables for the image data, the final image object, and the depth buffer
local imageData, image, zBuffer

-- Initialise the Z-buffer (depth buffer)
-- Returns a 2D table filled with 0, representing the furthest depth
local function initZBuffer()
    local buffer = {}
    for y = 1, height do
        buffer[y] = {}
        for x = 1, width do
            buffer[y][x] = 0
        end
    end
    return buffer
end

-- Main rendering function: draws the torus onto the `imageData` using a z-buffer
local function drawTorus(imageData, zBuffer)
    -- Helper to convert lighting luminance into a colour (blue-ish gradient)
    local function colourFromLuminance(lum)
        local brightness = math.floor(lum*30)
        -- Clamp brightness between 0 and 255
        brightness = math.max(0, math.min(255, brightness))
        return brightness/255, brightness/255/2, 1, 1
    end

    -- Iterate over the major angle (theta) -- around the main ring
    -- 629 steps covers approx 2 * PI * 100
    for majorSteps = 1, 629 do
        local theta = (majorSteps - 1) / 100

        -- Iterate over the minor angle (phi) -- around the tube
        -- Step by 4 to reduce overdraw/performance cost
        for minorSteps = 1, 628, 4 do
            local phi = (minorSteps - 1) / 100

            -- Pre-calculate trig values for the current point on the torus
            local sinMinor = math.sin(phi)
            local cosMinor = math.cos(phi)
            local sinMajor = math.sin(theta)
            local cosMajor = math.cos(theta)

            -- Calculate 3D coordinates (x, y, z) based on torus parametric equations and
            -- applied rotation matrices (A and B)
            local intermediateRadius = outerRadius + innerRadius * cosMajor
            local x = intermediateRadius * (cosB * cosMinor + sinA * sinB * sinMinor) - innerRadius * cosA * sinB * sinMajor
            local y = intermediateRadius * (sinB * cosMinor - sinA * cosB * sinMinor) + innerRadius * cosA * cosB * sinMajor
            local z = intermediateRadius * cosA * sinMinor + innerRadius * sinA * sinMajor

            -- Calculate lighting (luminance) based on surface normal incidence -- this creates
            -- the shading effect on the 3D shape
            local incidence = cosMajor * cosMinor * sinB - sinA * cosMajor * sinMinor * cosB - cosA * sinMajor * cosB
            local luminance = 8 * (incidence - cosMinor * sinMajor * sinA)

            -- Only draw if the surface is facing the light/camera (luminance > 0)
            if luminance > 0 then
                local r, g, b, a = colourFromLuminance(luminance)

                -- Perspective projection
                -- ooz = One Over Z
                -- Adds 500 to Z to move the object in front of the camera
                local ooz = 1 / (z + 500)
                -- Project 3D coordinates to 2D screen space, centred at 400, 300
                local xp = round(400+x*ooz*600+0.5)
                local yp = round(300-y*ooz*600+0.5)

                -- Check bounds to ensure we don't draw outside the screen
                if (0 <= xp and xp < width) and (0 <= yp and yp < height) then
                    -- Note: `imageData` is 0-indexed, but `zBuffer` table is 1-indexed, hence yp+1/xp+1
                    -- If the new point is closer (higher `ooz`) than what is stored, draw it
                    if zBuffer[yp+1] and zBuffer[yp+1][xp+1] and ooz > zBuffer[yp+1][xp+1] then
                        zBuffer[yp+1][xp+1] = ooz
                        imageData:setPixel(xp, yp, r, g, b, a)
                    end
                end
            end
        end
    end
end

-- Load assets and initialise the scene
function love.load()
    love.window.setTitle("3D torus in LÖVE")
    love.window.setMode(width, height)

    -- Create depth buffer and image data container
    zBuffer = initZBuffer()
    imageData = love.image.newImageData(width, height)

    -- Perform the software rendering pass
    drawTorus(imageData, zBuffer)

    -- Convert raw image data into a GPU texture for drawing
    image = love.graphics.newImage(imageData)
end

-- Draw the pre-rendered image to the screen
function love.draw()
    love.graphics.draw(image, 0, 0)
end

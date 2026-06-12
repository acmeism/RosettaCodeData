-- Computes the squared Euclidean distance between two RGB colors.
-- This avoids a square root for performance, since we only need relative
-- comparisons.
local function colourDifference(colour1, colour2)
    local rDiff = colour2[1] - colour1[1]
    local gDiff = colour2[2] - colour1[2]
    local bDiff = colour2[3] - colour1[3]

    return rDiff * rDiff + gDiff * gDiff + bDiff * bDiff
end

-- Finds the colour in `palette` that is visually closest to `colour` using the
-- squared Euclidean distance (via `colourDifference`).
local function closestColour(colour, palette)
    local closest = palette[1]  -- Initialise with first palette color
    for _, n in ipairs(palette) do
        if colourDifference(colour, n) < colourDifference(colour, closest) then
            closest = n
        end
    end
    return closest
end

-- Clamps a value between 0 and 1 (inclusive).
-- Ensures color components stay within valid normalised range [0,1].
local function clamp(value)
    return math.max(0, math.min(1, value))
end

-- Global variables to store original and dithered images, and a toggle state
-- (1 = original, 2 = dithered).
local image, dithered
local current = 1

-- Define a standard 8-color RGB palette (each component is either 0 or 1).
-- This represents all combinations of fully on/off red, green, and blue.
local floydSteinbergPalette = {
    {0, 0, 0},
    {0, 0, 1},
    {0, 1, 0},
    {0, 1, 1},
    {1, 0, 0},
    {1, 0, 1},
    {1, 1, 0},
    {1, 1, 1}
}

-- Applies Floyd-Steinberg dithering to an `ImageData` object.
-- Returns a new `Image` suitable for drawing.
local function fsDither(imageData)
    local imageWidth = imageData:getWidth()
    local imageHeight = imageData:getHeight()

    -- Create a working copy of the image as a 2D table of {r, g, b, a} values.
    local work = {}
    for y = 1, imageHeight do
        work[y] = {}
        for x = 1, imageWidth do
            local r, g, b, a = imageData:getPixel(x-1, y-1)
            work[y][x] = {r, g, b, a}
        end
    end

    -- Prepare output `ImageData` with same dimensions
    local ditheredData = love.image.newImageData(imageWidth, imageHeight)

    -- Process each pixel in raster order (left-to-right, top-to-bottom)
    for y = 1, imageHeight do
        for x = 1, imageWidth do
            local current = work[y][x]
            local r, g, b, a = current[1], current[2], current[3], current[4]

            -- Clamp input colour to valid [0,1] range before quantisation
            local clamped = {clamp(r), clamp(g), clamp(b)}
            -- Find the closest colour in the palette
            local newColour = closestColour(clamped, floydSteinbergPalette)
            -- Set the quantised pixel in the output image (preserve alpha)
            ditheredData:setPixel(x-1, y-1, newColour[1], newColour[2], newColour[3], a)

            -- Compute quantisation error (difference between original and quantised)
            local quantErrorR = r - newColour[1]
            local quantErrorG = g - newColour[2]
            local quantErrorB = b - newColour[3]

            -- Distribute the error to neighbouring pixels according to Floyd-Steinberg weights:
            --       X   7/16
            -- 3/16 5/16 1/16

            -- Right neighbour (same row)
            if x < imageWidth then
                work[y][x+1][1] = work[y][x+1][1] + quantErrorR * (7 / 16)
                work[y][x+1][2] = work[y][x+1][2] + quantErrorG * (7 / 16)
                work[y][x+1][3] = work[y][x+1][3] + quantErrorB * (7 / 16)
            end

            -- Next row neighbours (only if not on last row)
            if y < imageHeight then
                -- Bottom-left neighbour
                if x > 1 then
                    work[y+1][x-1][1] = work[y+1][x-1][1] + quantErrorR * (3 / 16)
                    work[y+1][x-1][2] = work[y+1][x-1][2] + quantErrorG * (3 / 16)
                    work[y+1][x-1][3] = work[y+1][x-1][3] + quantErrorB * (3 / 16)
                end

                -- Bottom neighbour
                work[y+1][x][1] = work[y+1][x][1] + quantErrorR * (5 / 16)
                work[y+1][x][2] = work[y+1][x][2] + quantErrorG * (5 / 16)
                work[y+1][x][3] = work[y+1][x][3] + quantErrorB * (5 / 16)

                -- Bottom-right neighbour
                if x < imageWidth then
                    work[y+1][x+1][1] = work[y+1][x+1][1] + quantErrorR * (1 / 16)
                    work[y+1][x+1][2] = work[y+1][x+1][2] + quantErrorG * (1 / 16)
                    work[y+1][x+1][3] = work[y+1][x+1][3] + quantErrorB * (1 / 16)
                end
            end
        end
    end

    -- Return a drawable `Image` object from the processed `ImageData`
    return love.graphics.newImage(ditheredData)
end

-- Called once at startup. Loads an image and applies dithering.
function love.load(args)
    -- Use first command-line argument as image filename, or default to "Lenna.png"
    local sampleFileName = args[1] or "Lenna.png"

    love.window.setTitle("Loading...")

    -- Load the source image
    local imageData = love.image.newImageData(sampleFileName)
    image = love.graphics.newImage(imageData)
    -- Generate the dithered version
    dithered = fsDither(imageData)

    -- Resize window to match image dimensions
    love.window.setMode(image:getDimensions())
end

-- Called every frame to draw the screen.
function love.draw()
    love.window.setTitle("Floyd-Steinberg dithering algorithm in LÖVE")

    -- Draw either the original or dithered image based on `current` toggle
    if current == 1 then
        love.graphics.draw(image)
    elseif current == 2 then
        love.graphics.draw(dithered)
    end
end

-- Handle key presses. Press Tab to toggle between original and dithered view.
function love.keypressed(key)
    if key == "tab" then
        current = 3 - current
    end
end

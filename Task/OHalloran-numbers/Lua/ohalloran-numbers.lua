function calculateOHalloranNumbers(maximumArea)
    local halfMaximumArea = maximumArea / 2
    local ohalloranNumbers = {}

    -- Initialize the ohalloranNumbers table with all true values
    for i = 1, halfMaximumArea do
        ohalloranNumbers[i] = true
    end

    -- Calculate surface areas of possible cuboids and exclude them
    for length = 1, maximumArea - 1 do
        for width = 1, halfMaximumArea - 1 do
            for height = width, halfMaximumArea - 1 do
                local halfArea = length * width + length * height + width * height
                if halfArea < halfMaximumArea then
                    ohalloranNumbers[halfArea] = false
                else
                    break
                end
            end
            if length * width * 2 >= halfMaximumArea then
                break
            end
        end
    end

    -- Print out the O'Halloran numbers
    print("Values larger than 6 and less than " .. maximumArea .. " which cannot be the surface area of a cuboid:")
    for i = 3, halfMaximumArea-1 do
        if ohalloranNumbers[i] then
            io.write((2 * (i)) .. " ")
        end
    end
    print()
end

-- Call the function with the maximum area of 1000
calculateOHalloranNumbers(1000)

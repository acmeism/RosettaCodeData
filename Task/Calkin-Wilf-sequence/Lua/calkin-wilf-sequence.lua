do  -- Calculate members of the Calkin-Wilf sequence

    local n, d = 0, 0

    local function firstCW()
        n, d = 1, 1
    end

    local function nextCW()
        n, d = d, ( d + ( 2 * d * ( n // d ) ) ) - n
    end

    io.write( "The first 20 elements of the Calkin-Wilf sequence are:\n    " )
    firstCW()
    for i = 1, 20 do
       io.write( " " .. n .. "/" .. d )
       nextCW()
    end
    io.write( "\n" )

    firstCW()
    local pos = 1
    while n ~= 83116 or d ~= 51639 do
       nextCW()
       pos = pos + 1
    end
    io.write( "Position of 83116/51639 in the sequence: " .. pos .. "\n" )

end

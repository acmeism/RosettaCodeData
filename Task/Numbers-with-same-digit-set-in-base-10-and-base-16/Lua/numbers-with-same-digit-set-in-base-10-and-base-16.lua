do  -- find numbers with the same digit set in decimal and hex - translated from the EasyLang sample

    local function digest( n, b )
        local v, dset = n, 0
        while v > 0 do
            dset = dset | ( 1 << ( v % b ) )
            v = v // b
        end
        return dset
    end

    local hdCount = 0
    for i = 0, 100000 - 1 do
        if digest( i, 10 ) == digest( i, 16 ) then
            io.write( string.format( " %5d", i ) )
            hdCount = hdCount + 1
            if hdCount % 10 == 0 then io.write( "\n" ) end
        end
    end

end

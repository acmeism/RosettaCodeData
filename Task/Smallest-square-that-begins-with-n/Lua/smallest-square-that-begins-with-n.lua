do -- find the smallest square that begins with n for n in 1..49
    local function smsq( n )
        local results, found, square, delta = {}, 0, 1, 3
        while found < n do
            local k = square
            while k > 0 do
                if k <= n and results[ k ] == nil then
                    results[ k ] = square
                    found = found + 1
                end
                k = math.floor( k / 10 )
            end
            square = square + delta
            delta  = delta + 2
        end
        return results
    end

    local seq = smsq( 49 )
    for i = 1, #seq do
        io.write( " ", string.format( "%5d", seq[ i ] ) )
        if i % 10 == 0 then io.write( "\n" ) end
    end
end

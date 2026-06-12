do  -- find members of the coprime triplets sequence starting from 1, 2 the
    -- subsequent members are the lowest number coprime to the previous two
    -- that haven't appeared in the sequence yet

    -- iterative Greatest Common Divisor routine, returns the gcd of m and n
    local function gcd ( m, n )
        local a, b = math.abs( m ), math.abs( n )
        while b ~= 0 do
            a, b = b, a % b
        end
        return a
    end
    -- returns an array of the coprime triplets up to n
    local function coprimeTriplets( n )
        local result = {}
        if n > 0 then
            result[ 1 ] = 1
            if n > 1 then
                local used = {}
                used[ 1 ], used[ 2 ] = true, true
                result[ 2 ] = 2
                for i = 3, n do used[ i ], result[ i ] = false, 0 end
                for i = 3, n do
                    local p1 <const>, p2 <const> = result[ i - 1 ], result[ i - 2 ]
                    local found = false
                    for j = 1, n do
                        if not used[ j ] then
                            found = gcd( p1, j ) == 1 and gcd( p2, j ) == 1
                            if found then
                                used[   j ] = true
                                result[ i ] = j
                                break
                            end
                        end
                    end
                end
            end
        end
        return result
    end

    local cps <const> = coprimeTriplets( 49 )
    local printed = 0
    for i = 1, # cps do
        if cps[ i ] ~= 0 then
            io.write( " ", cps[ i ] )
            printed = printed + 1
        end
    end
    io.write( "\nFound ", printed, " coprime triplets up to ", # cps, "\n" )
end

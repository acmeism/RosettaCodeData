do -- find numbers palendromic in bases 2, 4, and 16

    local function palendromic( n, base )
        local digits, v = "", n
        while v > 0 do
            local dPos = ( v % base ) + 1
            digits = digits..string.sub( "0123456789abcdef", dPos, dPos )
            v = math.floor( v / base )
        end
        return digits == string.reverse( digits )
    end
    -- as noted by the REXX sample, all even numbers end in 0 in base 2
    -- so 0 is the only possible even number, note 0 is palendromic in all bases
    io.write( " 0" )
    for n = 1, 24999, 2 do
        if palendromic( n, 16 ) then
            if palendromic( n, 4 ) then
                if palendromic( n, 2 ) then
                    io.write( " ", n )
                end
            end
        end
    end
end

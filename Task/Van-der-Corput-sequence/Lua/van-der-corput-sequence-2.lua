function vdc( nth, base ) -- returns the numerator & denominator of the sequence element n in base
    local p, q, n = 0, 1, nth
    while n ~= 0 do
        p = p * base
        p = p + n % base;
        q = q * base;
        n = math.floor( n / base )
    end
    local num, denom = p, q;
    -- reduce the numerator and denominator by their gcd
    while p ~= 0 do
        n = p
        p = q % p
        q = n
    end
    num   = math.floor( num   / q )
    denom = math.floor( denom / q )
    return num, denom
end
for b = 2,5 do
    io.write( "base ", b, ": " )
    for n = 0,9 do
        local num, denom = vdc( n, b )
        io.write( " ", num ) if num ~= 0 then io.write( "/", denom ) end
    end
    io.write( "\n" )
end

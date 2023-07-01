function gcd_bin(integer u, integer v)
    integer t, k
    if u < 0 then -- abs(u)
        u = -u
    end if
    if v < 0 then -- abs(v)
        v = -v
    end if
    if u < v then
        t = u
        u = v
        v = t
    end if
    if v = 0 then
        return u
    end if
    k = 1
    while and_bits(u,1) = 0 and and_bits(v,1) = 0 do
        u = floor(u/2) -- u >>= 1
        v = floor(v/2) -- v >>= 1
        k *= 2 -- k <<= 1
    end while
    if and_bits(u,1) then
        t = -v
    else
        t = u
    end if
    while t do
        while and_bits(t, 1) = 0 do
            t = floor(t/2)
        end while
        if t > 0 then
            u = t
        else
            v = -t
        end if
        t = u - v
    end while
    return u * k
end function

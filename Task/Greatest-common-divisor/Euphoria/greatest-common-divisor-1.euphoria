function gcd_iter(integer u, integer v)
    integer t
    while v do
        t = u
        u = v
        v = remainder(t, v)
    end while
    if u < 0 then
        return -u
    else
        return u
    end if
end function

function gcd(integer m, integer n)
    integer tmp
    while m do
        tmp = m
        m = remainder(n,m)
        n = tmp
    end while
    return n
end function

function lcm(integer m, integer n)
    return m / gcd(m, n) * n
end function

function gray_encode(integer n)
    return xor_bits(n,floor(n/2))
end function

function gray_decode(integer n)
    integer g
    g = 0
    while n > 0 do
        g = xor_bits(g,n)
        n = floor(n/2)
    end while
    return g
end function

function dcb(integer n)
    atom d,m
    d = 0
    m = 1
    while n do
        d += remainder(n,2)*m
        n = floor(n/2)
        m *= 10
    end while
    return d
end function

integer j
for i = #0 to #1F do
    printf(1,"%05d => ",dcb(i))
    j = gray_encode(i)
    printf(1,"%05d => ",dcb(j))
    j = gray_decode(j)
    printf(1,"%05d\n",dcb(j))
end for

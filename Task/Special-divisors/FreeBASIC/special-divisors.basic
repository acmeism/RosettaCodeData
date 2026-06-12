function reverse(n as integer) as integer
    dim as integer u = 0
    while n
        u = 10*u + n mod 10
        n\=10
    wend
    return u
end function

dim as integer n, u, d, b
dim as boolean s

for n = 1 to 200
    u = reverse(n)
    s = true
    for d = 1 to n
        if n mod d = 0 then
            b = reverse(d)
            if u mod b <> 0 then s = false
        end if
    next d
    if s then print using "### ";n;
next n

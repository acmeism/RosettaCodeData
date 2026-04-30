function randN(integer N)
    return rand(N) = 1
end function

function unbiased(integer N)
    integer a
    while 1 do
        a = randN(N)
        if a != randN(N) then
            return a
        end if
    end while
end function

constant n = 10000
integer cb, cu
for b = 3 to 6 do
    cb = 0
    cu = 0
    for i = 1 to n do
        cb += randN(b)
        cu += unbiased(b)
    end for
    printf(1, "%d: %5.2f%%  %5.2f%%\n", {b, 100 * cb / n, 100 * cu / n})
end for

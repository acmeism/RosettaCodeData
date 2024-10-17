function is_happy(integer n)
    sequence seen
    integer k
    seen = {}
    while n > 1 do
        seen &= n
        k = 0
        while n > 0 do
            k += power(remainder(n,10),2)
            n = floor(n/10)
        end while
        n = k
        if find(n,seen) then
            return 0
        end if
    end while
    return 1
end function

integer n,count
n = 1
count = 0
while count < 8 do
    if is_happy(n) then
        ? n
        count += 1
    end if
    n += 1
end while

function hailstone(atom n)
    sequence s
    s = {n}
    while n != 1 do
        if remainder(n,2)=0 then
            n /= 2
        else
            n = 3*n + 1
        end if
        s &= n
    end while
    return s
end function

function hailstone_count(atom n)
    integer count
    count = 1
    while n != 1 do
        if remainder(n,2)=0 then
            n /= 2
        else
            n = 3*n + 1
        end if
        count += 1
    end while
    return count
end function

sequence s
s = hailstone(27)
puts(1,"hailstone(27) =\n")
? s
printf(1,"len = %d\n\n",length(s))

integer max,imax,count
max = 0
for i = 2 to 1e5-1 do
    count = hailstone_count(i)
    if count > max then
        max = count
        imax = i
    end if
end for

printf(1,"The longest hailstone sequence under 100,000 is %d with %d elements.\n",
    {imax,max})

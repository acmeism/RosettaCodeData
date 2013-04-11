function vdc(integer n, atom base)
    atom vdc, denom, rem
    vdc = 0
    denom = 1
    while n do
        denom *= base
        rem = remainder(n,base)
        n = floor(n/base)
        vdc += rem / denom
    end while
    return vdc
end function

for i = 2 to 5 do
    printf(1,"Base %d\n",i)
    for j = 0 to 9 do
        printf(1,"%g ",vdc(j,i))
    end for
    puts(1,"\n\n")
end for

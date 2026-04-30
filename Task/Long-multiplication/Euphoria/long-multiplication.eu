constant base = 1000000000

function atom_to_long(atom a)
    sequence s
    s = {}
    while a>0 do
        s = append(s,remainder(a,base))
        a = floor(a/base)
    end while
    return s
end function

function long_mult(object a, object b)
    sequence c
    if atom(a) then
        a = atom_to_long(a)
    end if
    if atom(b) then
        b = atom_to_long(b)
    end if
    c = repeat(0,length(a)+length(b))
    for i = 1 to length(a) do
        c[i .. i+length(b)-1] += a[i]*b
    end for

    for i = 1 to length(c) do
        if c[i] > base then
            c[i+1] += floor(c[i]/base) -- carry
            c[i] = remainder(c[i],base)
        end if
    end for

    if c[$] = 0 then
        c = c[1..$-1]
    end if
    return c
end function


function long_to_str(sequence a)
    sequence s
    s = sprintf("%d",a[$])
    for i = length(a)-1 to 1 by -1 do
        s &= sprintf("%09d",a[i])
    end for
    return s
end function

sequence a, b, c

a = atom_to_long(power(2,32))
printf(1,"a is %s\n",{long_to_str(a)})

b = long_mult(a,a)
printf(1,"a*a is %s\n",{long_to_str(b)})

c = long_mult(b,b)
printf(1,"a*a*a*a is %s\n",{long_to_str(c)})

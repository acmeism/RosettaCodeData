' Factors of a Mersenne number
    for i=1 to 59
        z=i
        if z=59 then z=929  ':) 61 turns into 929.
        if isPrime(z) then
            r=testM(z)
            zz=left("M" & z & space(4),4)
            if r=0 then
                Wscript.echo zz & " prime."
            else
                Wscript.echo zz & " not prime, a factor: " & r
            end if
        end if
    next

function modPow(base,n,div)
    dim i,y,z
    i = n : y = 1 : z = base
    do while i
        if i and 1 then y = (y * z) mod div
        z = (z * z) mod div
        i = i \ 2
    loop
    modPow= y
end function

function isPrime(x)
    dim i
    if x=2 or x=3 or _
       x=5 or x=7 _
                  then isPrime=1: exit function
    if x<11       then isPrime=0: exit function
    if x mod 2=0  then isPrime=0: exit function
    if x mod 3=0  then isPrime=0: exit function
    i=5
    do
        if (x mod i)     =0 or _
           (x mod (i+2)) =0 _
                  then isPrime=0: exit function
        if i*i>x  then isPrime=1: exit function
        i=i+6
    loop
end function

function testM(x)
    dim sqroot,k,q
    sqroot=Sqr(2^x)
    k=1
    do
        q=2*k*x+1
        if q>sqroot then exit do
        if (q and 7)=1 or (q and 7)=7 then
            if isPrime(q) then
                if modPow(2,x,q)=1 then
                    testM=q
                    exit function
                end if
            end if
        end if
        k=k+1
    loop
    testM=0
end function

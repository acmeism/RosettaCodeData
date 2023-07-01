dim as ulongint E(0 to 15), k
dim as integer i, em
E(0) = 2 : print 2
for i=1 to 15
    k=3
    do
        em = 1
        for j as uinteger = 0 to i-1
            em = (em*E(j)) mod k
        next j
        em = (em + 1) mod k
        if em = 0 then
            E(i)=k
            print E(i)
            exit do
        end if
        k = k + 2
    loop
next i

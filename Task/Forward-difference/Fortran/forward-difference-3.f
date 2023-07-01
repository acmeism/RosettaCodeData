function forward_difference( a() as uinteger ) as uinteger ptr
    dim as uinteger ptr b = allocate( sizeof(uinteger) * (ubound(a)-1) )
    for i as uinteger = 0 to ubound(a)-1
        *(b+i) = a(i+1)-a(i)
    next i
    return b
end function

dim as uinteger a(0 to 15) = {2, 3, 5, 7, 11, 13, 17, 19,_
                         23, 29, 31, 37, 41, 43, 47, 53}
dim as uinteger i

dim as uinteger ptr b = forward_difference( a() )

for i = 0 to ubound(a)-1
    print *(b+i)
next i

redim arr(-1) as uinteger
dim as uinteger i
for a as uinteger = 2 to 5
    for b as uinteger = 2 to 5
        redim preserve arr(0 to ubound(arr)+1)
        i = ubound(arr)
        arr(i) = a^b
        while arr(i-1)>arr(i) and i > 0
            swap arr(i-1), arr(i)
            i -= 1
        wend
    next b
next a

for i = 0 to ubound(arr)
    if arr(i)<>arr(i-1) then print arr(i),
next i

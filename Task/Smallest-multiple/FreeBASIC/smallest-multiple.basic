#include"lcm.bas"

redim shared as ulongint smalls(0 to 1)  'calculate and store as we go
smalls(0) = 0: smalls(1) = 1

function smalmul(n as longint) as ulongint
    if n<0 then return smalmul(-n)     'deal with negative input
    dim as uinteger m = ubound(smalls)
    if n<=m then return smalls(n)  'have we calculated this already
    'if not, make room for the next bunch of terms
    redim preserve as ulongint smalls(0 to n)
    for i as uinteger = m+1 to n
        smalls(i) = lcm(smalls(i-1), i)
    next i
    return smalls(n)
end function

for i as uinteger = 0 to 20
    print i, smalmul(i)
next i

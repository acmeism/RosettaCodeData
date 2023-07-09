maxNumber      = 20000
abundantCount  = 0
deficientCount = 0
perfectCount   = 0

pds = list( maxNumber )
pds[ 1 ] = 0
for i = 2 to maxNumber pds[ i ] = 1 next
for i = 2 to maxNumber
    for j = i + i to maxNumber step i pds[ j ] = pds[ j ] + i next
next
for n = 1 to maxNumber
    pdSum = pds[ n ]
    if     pdSum <  n
        deficientCount = deficientCount + 1
    but    pdSum = n
        perfectCount   = perfectCount + 1
    else # pdSum >  n
        abundantCount  = abundantCount + 1
    ok
next

see "Abundant : " + abundantCount  + nl
see "Deficient: " + deficientCount + nl
see "Perfect  : " + perfectCount   + nl

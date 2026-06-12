function hpo2( n as uinteger ) as uinteger
    'highest power of 2 that divides a given number
    return n and -n
end function

function lhpo2( n as uinteger ) as uinteger
    'base 2 logarithm of the highest power of 2 dividing a given number
    dim as uinteger q = 0, m = hpo2( n )
    while m mod 2 = 0
        m = m shr 1
        q += 1
    wend
    return q
end function

function nimsum(x as uinteger, y as uinteger) as uinteger
    'nim-sum of two numbers
    return x xor y
end function

function nimprod(x as uinteger, y as uinteger) as uinteger
    'nim-product of two numbers
    if x < 2 orelse y < 2 then return x*y
    dim as uinteger h = hpo2(x)
    if x > h then return nimprod(h, y) xor nimprod(x xor h, y)  'recursively break x into its powers of 2
    if hpo2(y) < y then return nimprod(y, x)     'recursively break y into its powers of 2 by flipping the operands
    'now both x and y are powers of two
    dim as uinteger xp = lhpo2(x), yp = lhpo2(y), comp = xp and yp
    if comp = 0 then return x*y    'we have no fermat power in common
    h = hpo2(comp)
    return nimprod(nimprod(x shr h, y shr h), 3 shl (h - 1)) 'a fermat number square is its sequimultiple
end function

'print tables

function padto( i as ubyte, j as integer ) as string
    return wspace(i-len(str(j)))+str(j)
end function

dim as uinteger a, b
dim as string outstr

outstr = " + | "
for a = 0 to 15
    outstr += padto(2, a)+" "
next a
print outstr
print "--- -------------------------------------------------"
for b = 0 to 15
    outstr = padto(2, b)+ " | "
    for a = 0 to 15
        outstr += padto(2, nimsum(a,b))+" "
    next a
    print outstr
next b
print
outstr = " * | "
for a = 0 to 15
    outstr += padto(2, a)+" "
next a
print outstr
print "--- -------------------------------------------------"
for b = 0 to 15
    outstr = padto(2, b)+ " | "
    for a = 0 to 15
        outstr += padto(2, nimprod(a,b))+" "
    next a
    print outstr
next b
print
a = 21508
b = 42689

print using "##### + ##### = ##########"; a; b; nimsum(a,b)
print using "##### * ##### = ##########"; a; b; nimprod(a,b)

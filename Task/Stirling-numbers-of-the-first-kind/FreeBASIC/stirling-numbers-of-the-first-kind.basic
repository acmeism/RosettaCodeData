dim as integer S1(0 to 12, 0 to 12)   'initially set with zeroes
dim as ubyte n, k
dim as string outstr

function padto( i as ubyte, j as integer ) as string
    return wspace(i-len(str(j)))+str(j)
end function

S1(0, 0) = 1

for n = 0 to 12   'calculate table
    for k = 1 to n
        S1(n, k) = S1(n-1, k-1) - (n-1) * S1(n-1, k)
    next k
next n

print "Signed Stirling numbers of the first kind"
print
outstr = "   k"
for k=0 to 12
    outstr += padto(12, k)
next k
print outstr
print " n"
for n = 0 to 12
    outstr = padto(2, n)+"  "
    for k = 0 to 12
        outstr += padto(12, S1(n, k))
    next k
    print outstr
next n

dim as integer S2(0 to 12, 0 to 12)   'initially set with zeroes
dim as ubyte n, k
dim as string outstr

function padto( i as ubyte, j as integer ) as string
    return wspace(i-len(str(j)))+str(j)
end function

for k = 0 to 12   'calculate table
    S2(k,k)=1
next k
for n = 1 to 11
    for k = 1 to 12
        S2(n+1,k) = k*S2(n,k) + S2(n,k-1)
    next k
next n

print "Stirling numbers of the second kind"
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
        outstr += padto(12, S2(n, k))
    next k
    print outstr
next n

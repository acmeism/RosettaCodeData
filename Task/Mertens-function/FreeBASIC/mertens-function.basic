function padto( i as ubyte, j as integer ) as string
    return wspace(i-len(str(j)))+str(j)
end function

dim as integer M( 1 to 1000 ), n, col, k, psum
dim as integer num_zeroes = 0, num_cross = 0
dim as string outstr

M(1) = 1
for n = 2 to 1000
    psum = 0
    for k = 2 to n
        psum += M(int(n/k))
    next k
    M(n) = 1 - psum
    if M(n) = 0 then
        num_zeroes += 1
        if M(n-1)<>0 then
            num_cross += 1
        end if
    end if
next n

print using "There are ### zeroes in the range 1 to 1000."; num_zeroes
print using "There are ### crossings in the range 1 to 1000."; num_cross
print "The first 100 Mertens numbers are: "

for n=1 to 100
    outstr += padto(3, M(n))+"  "
    if n mod 10 = 0 then
        print outstr
        outstr = ""
    end if
next n

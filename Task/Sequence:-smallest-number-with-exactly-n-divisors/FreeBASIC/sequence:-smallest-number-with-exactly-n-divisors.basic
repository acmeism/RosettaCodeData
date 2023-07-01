#define UPTO 15

function divisors(byval n as ulongint) as uinteger
    'find the number of divisors of an integer
    dim as integer r = 2, i
    for i = 2 to n\2
        if n mod i = 0 then r += 1
    next i
    return r
end function

dim as ulongint i = 2
dim as integer n, nfound = 1, sfound(UPTO) = {1}

while nfound < UPTO
    n = divisors(i)
    if n<=UPTO andalso sfound(n)=0 then
        nfound += 1
        sfound(n) = i
    end if
    i+=1
wend

print 1;" ";    'special case
for i = 2 to UPTO
    print sfound(i);" ";
next i
print
end

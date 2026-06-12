#include once "isprime.bas"

dim as integer p = 2, n = 1

print 2;" ";

do
    if isprime(p + n^3) then
        p += n^3
        n = 1
        print p;" ";
    else
        n += 1
    end if
loop until p + n^3 >= 15000
print
end

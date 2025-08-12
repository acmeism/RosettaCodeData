load "stdlib.ring"

flag = 0
p = 3
while flag < 10
    m=(pow(2,p)+1)/3
    if isPrime(m) and isPrime(p) and p%2=1
       see "p = " + p +", " + "m = " + m + nl
       flag++
    ok
    p = p + 2
end

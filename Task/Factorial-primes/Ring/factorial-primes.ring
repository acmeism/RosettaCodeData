see "working..." + nl
load "stdlibcore.ring"

n = 0
num = 0
while true
        n++
        n1 = factorial(n) - 1
        if isPrime(n1)
           num++
           see "" + num + ": " + n + "! - 1 = " + n1 + nl
        ok
        n2 = factorial(n) + 1
        if isPrime(n2)
           num++
           see "" + num + ": " + n + "! + 1 = " + n2 + nl
        ok
        if num = 10
           exit
        ok
end
see "done..." + nl

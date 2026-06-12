load "stdlibcore.ring"
see "working..." + nl
n = 0
num = 0

while true
     n++
     sum = 2*n+1
     if isprime(sum)
        num++
        if num < 21
          ? "" + n + " + " + (n+1) + " = " + sum
        else
          exit
        ok
      ok
end

see "done..." + nl

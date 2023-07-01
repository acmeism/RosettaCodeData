# Project : Loops/Increment loop index within loop body

load "stdlib.ring"
i = 42
n = 0
while n < 42
         if isprime(i)
            n = n + 1
            see "n = " + n + "    " + i + nl
            i = i + i - 1
         ok
         i = i + 1
end

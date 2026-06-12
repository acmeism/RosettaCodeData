load "stdlib.ring"

nr2 = 1
np = 1

while nr2 < 11
      fi = fib(np)
      fiStr = string(fi)
      rev2 = reverse(fiStr)
      fiNum = number(rev2)
      if (isPrime(fiNum) = 1)
         ? fiNum
         nr2 += 1
      ok
      np += 1
end

func fib nr if nr = 0 return 0 ok
            if nr = 1 return 1 ok
            if nr > 1 return fib(nr-1) + fib(nr-2) ok

see "working..." + nl
see "The first 4 Giuga numbers are:" + nl
load "stdlibcore.ring"

Comp = []
num = 0
n = 1
while true
      n++
      if not isPrime(n)
         Comp = []
         for p = 1 to n
             if isPrime(p) AND (n % p = 0)
                 add(Comp,p)
             ok
         next
         flag = 1
         for ind = 1 to len(Comp)
             f = Comp[ind]
             res = (n/f)- 1
             if res % f != 0
                flag = 0
                exit
             ok
         next
         if flag = 1
            see "" + n + " "
            num++
         ok
         if num = 4
            exit
         ok
      ok
end
see nl + "done..." + nl

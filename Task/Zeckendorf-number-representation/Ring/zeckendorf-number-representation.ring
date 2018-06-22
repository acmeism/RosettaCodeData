# Project : Zeckendorf number representation
# Date    : 2017/12/13
# Author : Gal Zsolt (~ CalmoSoft ~)
# Email   : <calmosoft@gmail.com>

see "0 0" + nl
for n = 1 to 20
     see "" + n + " " + zeckendorf(n) + nl
next

func zeckendorf(n)
       fib = list(45)
       fib[1] = 1
       fib[2] = 1
       i = 2
       o = ""
       while fib[i] <= n
               i = i + 1
               fib[i] = fib[i-1] + fib[i-2]
       end
       while i != 2
               i = i - 1
               if n >= fib[i]
                   o = o + "1"
                   n = n - fib[i]
               else
                   o = o + "0"
               ok
        end
        return o

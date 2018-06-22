# Project : Trabb Pardo–Knuth algorithm
# Date    : 2017/10/06
# Author : Gal Zsolt (~ CalmoSoft ~)
# Email   : <calmosoft@gmail.com>

decimals(3)
x = list(11)
for n=1 to 11
    x[n] = n
next

s = [-5, -3, -2, -1, 0, 1, 2, 3, 4, 5, 6]
for i = 1 to 11
    see string(i) + " => " + s[i] + nl
next
see copy("-", 20) + nl
i = i - 1

while i > 0
      see "f(" + string(s[i]) + ") = "
      x = f(s[i])
      if x > 400
         see "-=< overflow >=-" + nl
      else
         see x + nl
      ok
      i = i - 1
end

func f(n)
     return sqrt(fabs(n)) + 5 * pow(n, 3)

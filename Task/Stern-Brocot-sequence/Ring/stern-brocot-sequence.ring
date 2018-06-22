# Project : Stern-Brocot sequence
# Date    : 2018/02/01
# Author : Gal Zsolt [~ CalmoSoft ~]
# Email   : <calmosoft@gmail.com>

limit = 1200
item = list(limit+1)
item[1] = 1
item[2] = 1
nr = 2
gcd = 1
gcdall = 1
for num = 3 to limit
      item[num] = item[nr] + item[nr-1]
      item[num+1] = item[nr]
      nr = nr + 1
      num = num + 1
next
showarray(item,15)

for x = 1 to 100
      if x < 11 or x = 100
         totalitem(x)
      ok
next

for n = 1 to len(item) - 1
      if gcd(item[n],item[n+1]) != 1
         gcdall = gcd
      ok
next

if gcdall = 1
   see "Correct: The first 999 consecutive pairs are relative prime!" + nl
ok

func totalitem(p)
        pos = find(item, p)
        see string(x) + " at Stern #" + pos + "." + nl

func showarray(vect,ln)
        svect = ""
        for n = 1 to ln
              svect = svect + vect[n] + ", "
        next
        svect = left(svect, len(svect) - 2)
        see svect
        see nl

func gcd(gcd,b)
        while b
                  c = gcd
                  gcd = b
                  b = c % b
        end
        return gcd

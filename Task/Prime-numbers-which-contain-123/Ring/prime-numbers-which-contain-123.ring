load "stdlib.ring"
row = 0

see "working..." + nl
see "Prime numbers which contain 123 are:" + nl

for n = 1 to 100000
    strn = string(n)
    ind = substr(strn,"123")
    if isprime(n) and ind > 0
       see "" + n + " "
       row++
       if row%5 = 0
          see nl
       ok
    ok
next

see nl + "Found " + row + " numbers" + nl
see "done..." + nl

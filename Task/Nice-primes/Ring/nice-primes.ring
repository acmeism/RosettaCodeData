load "stdlib.ring"

num = 0
limit1 = 500
limit2 = 1000

see "working..." + nl
see "Nice numbers are:" + nl

for n = limit1 to limit2
    strn = string(n)
    while true
          sumn = 0
          for m = 1 to len(strn)
              sumn = sumn + number(strn[m])
          next
          if len(string(sumn)) = 1
             exit
          ok
          strn = string(sumn)
    end
    if isprime(n) and isprime(sumn)
       num = num + 1
       see "" + num + ": " + n + " > Σ = " + sumn + nl
    ok
next

see "done..." + nl

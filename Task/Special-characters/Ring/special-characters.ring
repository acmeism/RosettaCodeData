load "stdlib.ring"

see "Special characters in Ring:" + nl
for n = 1 to 255
    ch = char(n)
    if isSpecial(ch)
       see ch + nl
    ok
next

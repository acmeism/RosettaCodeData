# Project : Sattolo cycle

a = "123456789abcdefghijklmnopqrstuvwxyz"
n = len(a)
sit = list(n)

for i = 1 to n			
    sit[i] = substr(a, i, 1)
next
showsit()			
for i = n to 1 step -1
    j = floor(i * random(9)/10) + 1
    h = sit[i]
    sit[i] = sit[j]
    sit[j] = h
next
showsit()
			
func showsit
     for i = 1 to n
         see sit[i] + " "
     next
     see nl

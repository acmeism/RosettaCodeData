nr = 1000
num = 0
for n = 1 to nr
   sum = 0
   for m = 1 to len(string(n))
       sum += pow(number(substr(string(n),m,1)),2)
       if sum = 89 num += 1 see "" + n + " " + sum + nl ok
   next
next
see "Total under 1000 is : " + num + nl

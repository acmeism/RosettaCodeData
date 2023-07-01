# Project : Casting out nines

co9(1, 10, 99, [1,9,45,55,99])
co9(1, 10, 1000, [1,9,45,55,99,297,703,999])

func co9(start,base,lim,kaprekars)
c1=0
c2=0
s = []
for k = start to lim
     c1 = c1 + 1
      if k % (base-1) = (k*k) % (base-1)
         c2 = c2 + 1
         add(s,k)
      ok
next
msg = "Valid subset" + nl
for i = 1 to len(kaprekars)
     if not find(s,kaprekars[i])
       msg = "***Invalid***" + nl
       exit
     ok
next
showarray(s)
see "Kaprekar numbers:" + nl
showarray(kaprekars)
see msg
see "Trying " + c2 + " numbers instead of " + c1 + " saves " + (100-(c2/c1)*100) + "%" + nl + nl

func showarray(vect)
        see "{"
        svect = ""
        for n = 1 to len(vect)
              svect = svect + vect[n] + ", "
        next
        svect = left(svect, len(svect) - 2)
        see svect + "}" + nl

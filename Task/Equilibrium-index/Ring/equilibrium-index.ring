list  = [-7, 1, 5, 2, -4, 3, 0]
see "equilibrium indices are : " + equilibrium(list) + nl

func equilibrium l
     r = 0 s = 0 e = ""
     for n = 1 to len(l)
         s += l[n]
     next
     for i = 1 to len(l)
         if r = s - r - l[i]  e += string(i-1) + "," ok
         r += l[i]
     next
     e = left(e,len(e)-1)
     return e

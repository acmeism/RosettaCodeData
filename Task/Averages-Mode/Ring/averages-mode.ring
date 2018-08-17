# Project : Averages/Mode

a = [1, 3, 6, 6, 6, 6, 7, 7, 12, 12, 17]
b = [1, 2, 4, 4, 1]
amodes = list(12)
see "mode(s) of a() = " + nl
for i1 = 1 to modes(a,amodes)
     see "" + amodes[i1] + " "
next
see nl
see "mode(s) of b() = " + nl
for i1 = 1 to modes(b,amodes)
     see "" + amodes [i1]  + " "
next
see nl

func modes(a,amodes)
       max = 0
       n = len(a)
       if n = 0
          amodes[1] = a[1]
          return 1
       ok
       c = list(n)
       for i = 1 to n
            for j = i+1 to n
                 if a[i] = a[j]
                    c[i] = c[i] + 1
                 ok
            next
            if c[i] > max
               max = c[i]
            ok
        next
        j = 0
        for i = 1 to n
             if c[i] = max
                j = j + 1
                amodes[j] = a[i]
             ok
        next
        return j

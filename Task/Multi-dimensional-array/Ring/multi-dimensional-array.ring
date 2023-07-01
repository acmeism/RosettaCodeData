# Project : Multi-dimensional array

a4 = newlist4(5,4,3,2)

func main()
        m = 1
        for i = 1 to 5
             for j = 1 to 4
                  for k = 1 to 3
                        for l = 1 to 2
                             a4[i][j][k][l] = m
                             m = m + 1
                        next
                  next
             next
       next
       see "First element = " + a4[1][1][1][1] + nl
       a4[1][1][1][1] = 121
       see nl
       for i = 1 to 5
            for j = 1 to 4
                 for k = 1 to 3
                       for l = 1 to 2
                            see "" + a4[i][j][k][l] + " "
                       next
                 next
            next
      next

func newlist(x, y)
       if isstring(x) x=0+x ok
       if isstring(y) y=0+y ok
       alist = list(x)
       for t in alist
            t = list(y)
       next
       return alist

func newlist3(x, y, z)
       if isstring(x) x=0+x ok
       if isstring(y) y=0+y ok
       if isstring(z) z=0+z ok
       alist = list(x)
       for t in alist
            t = newlist(y,z)
       next
       return alist

func newlist4(x, y, z, w)
       if isstring(x) x=0+x ok
       if isstring(y) y=0+y ok
       if isstring(z) z=0+z ok
       if isstring(w) w=0+w ok
       alist = list(x)
       for t in alist
            t = newlist3(y,z,w)
       next
       return alist

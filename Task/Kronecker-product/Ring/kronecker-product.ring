# Project : Kronecker product

a = [[1, 2], [3, 4]]
b = [[0, 5], [6, 7]]
la1 = 1
ua1 = 2
la2 = 1
ua2 = 2
lb1 = 1
ub1 = 2
lb2 = 1
ub2 = 2
kroneckerproduct(a,b)
see nl

la1 = 1
ua1 = 3
la2 = 1
ua2 = 3
lb1 = 1
ub1 = 3
lb2 = 1
ub2 = 3
x = [[0, 1, 0], [1, 1, 1], [0, 1, 0]]
y = [[1, 1, 1, 1], [1, 0, 0, 1], [1, 1, 1, 1]]
kroneckerproduct(x, y)

func kroneckerproduct(a,b)


for i = la1 to ua1
      for k = lb1 to ub1
            see "["
            for j = la2 to ua2
                 for l = lb2 to ub2
                       see a[i][j] * b[k][l]
                       if j = ua1 and l = ub2
                          see "]" + nl
                       else
                          see " "
                       ok
                 next
            next
      next
next

# Project : Cholesky decomposition
# Date    : 2017/11/12
# Author : Gal Zsolt (~ CalmoSoft ~)
# Email   : <calmosoft@gmail.com>

load "stdlib.ring"
decimals(5)
m1 = [[25, 15, -5],
          [15, 18,  0],
          [-5,  0, 11]]
cholesky(m1)
printarray(m1)
see nl

m2 = [[18, 22,  54,  42],
          [22, 70,  86,  62],
          [54, 86, 174, 134],
          [42, 62, 134, 106]]
cholesky(m2)
printarray(m2)

func cholesky(a)
l = newlist(len(a), len(a))
for i = 1 to len(a)
     for j = 1 to i
         s = 0
         for k = 1 to j
             s = s + l[i][k] * l[j][k]
         next
         if i = j
            l[i][j] = sqrt(a[i][i] - s)
         else
            l[i][j] = (a[i][j] - s) / l[j][j]
         ok
    next
next
a = l

func printarray(a)
       for row = 1 to len(a)
            for col = 1 to len(a)
                 see "" + a[row][col] + "  "
            next
            see nl
       next

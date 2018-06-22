# Project : Spiral matrix
# Date    : 2018/03/23
# Author : Gal Zsolt [~ CalmoSoft ~]
# Email   : <calmosoft@gmail.com>

load "stdlib.ring"
n = 5
result = newlist(n,n)
k = 1
top = 1
bottom = n
left = 1
right = n
while (k<=n*n)
        for i=left to right
            result[top][i]=k
            k = k + 1
        next
        top = top + 1
        for i=top to bottom
            result[i][right]=k
            k = k + 1
        next
        right = right - 1
        for i=right to left step -1
            result[bottom][i]=k
            k = k + 1
        next
        bottom = bottom - 1
        for i=bottom to top step -1
            result[i][left] = k
            k = k + 1
        next
        left = left + 1
end
for m = 1 to n
     for p = 1 to n
          if m = 1
             see "  " + result[m][p]
          else
             see "" + result[m][p] + " "
          ok
     next
     see nl
next
see nl

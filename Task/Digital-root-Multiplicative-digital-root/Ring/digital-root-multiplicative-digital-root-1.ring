# Project : Digital root/Multiplicative digital root

load "stdlib.ring"
root = newlist(10, 5)
for r = 1 to 10
     for x = 1 to 5
          root[r][x] = 0
     next
next
root2 = list(10)
for y = 1 to 10
     root2[y] = 0
next
see "Number  MDR   MP" + nl
num = [123321, 7739, 893, 899998]
digroot(num)
see nl
num = 0:12000
digroot(num)
see "First five numbers with MDR in first column:" + nl
for n1 = 1 to 10
     see "" + (n1-1) + " => "
     for n2 = 1 to 5
         see "" + root[n1][n2] + "  "
     next
     see nl
next

func digroot(num)
        for n = 1 to len(num)
            sum = 0
            numold = num[n]
            while true
                    pro = 1
                    strnum = string(numold)
                    for nr = 1 to len(strnum)
                        pro = pro * number(strnum[nr])
                    next
                    sum = sum + 1
                    numold = pro
                    numn = string(num[n])
                    sp = 6 - len(string(num[n]))
                    if sp > 0
                       for p = 1 to sp + 2
                           numn = " " + numn
                       next
                    ok
                    if len(string(numold)) = 1 and len(num) < 5
                       see "" + numn + "     " + numold + "       " + sum + nl
                       exit
                    ok
                    if len(string(numold)) = 1 and len(num) > 4
                       root2[numold+1] = root2[numold+1] + 1
                       if root2[numold+1] < 6
                          root[numold+1][root2[numold+1]] = num[n]
                       ok
                       exit
                    ok
              end
        next

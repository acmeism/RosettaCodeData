load "stdlib.ring"

see "First 20 palindromic gapful numbers > 100 ending with each digit from 1 to 9:" + nl

limit = 9606069

for n = 1 to 9
    sum = 0
    for x = 101 to limit
        flag = 0
        strx = string(x)
        xbegin = left(strx,1)
        xend = right(strx,1)
        xnew = number(xbegin+xend)
        for y = 2 to ceil(x/2)+1
            if ispalindrome(strx)
               if y != xnew and x % y != 0
                  if x % xnew = 0 and number(xend) = n
                     flag = 1
                  else
                     flag = 0
                     exit
                  ok
               ok
            ok
        next
        if flag = 1
           sum = sum + 1
           if sum < 21
              see "x = " + x + nl
           else
              exit
           ok
        ok
    next
    see nl
next

see "done..." + nl

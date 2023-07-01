# Project : Pascal matrix generation

load "stdlib.ring"
res = newlist(5,5)

see "=== Pascal upper matrix ===" + nl
result = pascalupper(5)
showarray(result)

see nl + "=== Pascal lower matrix ===" + nl
result = pascallower(5)
showarray(result)

see nl + "=== Pascal symmetrical matrix ===" + nl
result = pascalsymmetric(5)
showarray(result)

func pascalupper(n)
    for m=1 to n
          for p=1 to n
               res[m][p] = 0
          next
    next
    for p=1 to n
         res[1][p] = 1
    next
    for i=2 to n
        for j=2 to i
            res[j][i] = res[j][i-1]+res[j-1][i-1]
        end
    end
    return res

func pascallower(n)
        for m=1 to n
              for p=1 to n
                   res[m][p] = 0
              next
        next
       for p=1 to n
             res[p][1] = 1
       next
       for i=2 to n
            for j=2 to i
                 res[i][j] = res[i-1][j]+res[i-1][j-1]
            next
        next
        return res

func pascalsymmetric(n)
        for m=1 to n
              for p=1 to n
                   res[m][p] = 0
              next
        next
        for p=1 to n
              res[p][1] = 1
              res[1][p] = 1
        next
        for i=2 to n
             for j = 2 to n
                  res[i][j] = res[i-1][j]+res[i][j-1]
             next
        next
        return res

func showarray(result)
        for n=1 to 5
              for m=1 to 5
                   see "" + result[n][m] + " "
              next
             see nl
        next

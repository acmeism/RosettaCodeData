# Project : Combinations

n = 5
k = 3
temp = []
comb = []
num = com(n, k)
while true
         temp = []
         for n = 1 to 3
               tm = random(4) + 1
               add(temp, tm)
         next
         bool1 = (temp[1] = temp[2]) and (temp[1] = temp[3]) and (temp[2] = temp[3])
         bool2 = (temp[1] < temp[2]) and (temp[2] < temp[3])
         if not bool1 and bool2
            add(comb, temp)
         ok
         for p = 1  to len(comb) - 1
               for q = p + 1 to len(comb)
                     if (comb[p][1] = comb[q][1]) and (comb[p][2] = comb[q][2]) and (comb[p][3] = comb[q][3])
                        del(comb, p)
                     ok
                next
         next
         if len(comb) = num
            exit
         ok
end
comb = sortfirst(comb, 1)
see showarray(comb) + nl

func com(n, k)
        res1 = 1
        for n1 = n - k + 1 to n
             res1 = res1 * n1
        next
        res2 = 1
        for n2 = 1 to k
              res2 = res2 * n2
        next
        res3 = res1/res2
        return res3

func showarray(vect)
        svect = ""
        for nrs = 1 to len(vect)
              svect = "[" + vect[nrs][1] + " " + vect[nrs][2] + " " + vect[nrs][3] + "]" + nl
              see svect
        next

Func sortfirst(alist, ind)
        aList = sort(aList,ind)
        for n = 1 to len(alist)-1
             for m= n + 1 to len(aList)
                  if alist[n][1] = alist[m][1] and alist[m][2] < alist[n][2]
                     temp = alist[n]
                     alist[n] = alist[m]
                     alist[m] = temp
                   ok
             next
        next
        for n = 1 to len(alist)-1
             for m= n + 1 to len(aList)
                  if alist[n][1] = alist[m][1] and alist[n][2] = alist[m][2] and alist[m][3] < alist[n][3]
                     temp = alist[n]
                     alist[n] = alist[m]
                     alist[m] = temp
                   ok
             next
       next
       return aList

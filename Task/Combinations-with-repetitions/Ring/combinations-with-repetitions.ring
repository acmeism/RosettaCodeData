# Project : Combinations with repetitions

n = 2
k = 3
temp = []
comb = []
num = com(n, k)
combinations(n, k)
comb = sortfirst(comb, 1)
see showarray(comb) + nl

func combinations(n, k)
while true
         temp = []
         for nr = 1 to k
               tm = random(n-1) + 1
               add(temp, tm)
         next
             add(comb, temp)
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

func com(n, k)
        res = pow(n, k)
        return res

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

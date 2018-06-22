# Project : Best shuffle
# Date    : 2018/02/15
# Author : Gal Zsolt (~ CalmoSoft ~)
# Email   : <calmosoft@gmail.com>

test = ["abracadabra", "seesaw", "elk", "grrrrrr", "up", "a"]

for n = 1 to len(test)
     bs   = bestshuffle(test[n])
     count = 0
     for p = 1 to len(test[n])
          if substr(test[n],p,1) = substr(bs,p,1)
             count = count + 1
          ok
      next
      see test[n] + " -> " + bs + " " + count + nl
next

func bestshuffle(s1)
       s2 = s1
       for i = 1 to len(s2)
            for j =  1 to len(s2)
                 if (i != j) and (s2[i] != s1[j]) and (s2[j] != s1[i])
                    if j < i
                       i1 = j
                       j1 = i
                    else
                       i1 = i
                       j1 = j
                    ok
                    s2 = left(s2,i1-1) + substr(s2,j1,1) + substr(s2,i1+1,(j1-i1)-1) + substr(s2,i1,1) + substr(s2,j1+1)
                 ok
            next
       next
       bestshuffle = s2
       return bestshuffle

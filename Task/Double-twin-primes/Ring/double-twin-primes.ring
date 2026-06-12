see "working..." + nl
P = []

limit = 1000
for n =1 to limit
    if isP(n)
       add(P,n)
    ok
next
lenP = len(P)-3
for m = 1 to lenP
    if isP(P[m]) AND isP(P[m+1]) AND isP(P[m+2]) AND isP(P[m+3])
       if (P[m+1] - P[m] = 2) AND (P[m+2] - P[m+1] = 4) AND (P[m+3] - P[m+2] = 2)
          see " " + P[m]+ " " + P[m+1] + " " + P[m+2] + " " + P[m+3] + nl
       ok
    ok
next

see "done..." + nl

func isP num
     if (num <= 1) return 0 ok
     if (num % 2 = 0 AND num != 2) return 0 ok
     for i = 3 to floor(num / 2) -1 step 2
         if (num % i = 0) return 0 ok
     next
return 1

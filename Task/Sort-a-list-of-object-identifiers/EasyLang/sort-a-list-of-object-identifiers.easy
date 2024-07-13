proc sort . d$[] .
   for s$ in d$[]
      d[][] &= number strsplit s$ "."
   .
   n = len d[][]
   for i = 1 to n - 1
      for j = i + 1 to n
         m = lower len d[i][] len d[j][]
         for k to m
            if d[i][k] <> d[j][k]
               break 1
            .
         .
         if k > m and len d[i][] > len d[j][] or d[i][k] > d[j][k]
            swap d[i][] d[j][]
         .
      .
   .
   for i to len d[][]
      d$[i] = d[i][1]
      for j = 2 to len d[i][]
         d$[i] &= "." & d[i][j]
      .
   .
.
oid$[] = [ "1.3.6.1.4.1.11.2.17.19.3.4.0.10" "1.3.6.1.4.1.11.2.17.5.2.0.79" "1.3.6.1.4.1.11.2.17.19.3.4.0.4" "1.3.6.1.4.1.11150.3.4.0.1" "1.3.6.1.4.1.11.2.17.19.3.4.0.1" "1.3.6.1.4.1.11150.3.4.0" ]
sort oid$[]
print oid$[]

proc hofstadter limit &q[] .
   q[] = [ 1 1 ]
   for n = 3 to limit
      q[] &= q[n - q[n - 1]] + q[n - q[n - 2]]
   .
.
proc count &q[] &cnt .
   for i = 2 to len q[]
      if q[i] < q[i - 1] : cnt += 1
   .
.
hofstadter 100000 hofq[]
for i = 1 to 10 : write hofq[i] & " "
print ""
print hofq[1000]
count hofq[] cnt
print cnt

proc minus . l[] r[] res[] .
   len res[] 3
   for i to 3
      res[i] = l[i] - r[i]
   .
.
func dot l[] r[] .
   for i to 3
      res += l[i] * r[i]
   .
   return res
.
proc scale f . l[] .
   for i to 3
      l[i] = l[i] * f
   .
.
proc inter_point rv[] rp[] pn[] pp[] . res[] .
   minus rp[] pp[] dif[]
   prd1 = dot dif[] pn[]
   prd2 = dot rv[] pn[]
   scale (prd1 / prd2) rv[]
   minus rp[] rv[] res[]
.
rv[] = [ 0.0 -1.0 -1.0 ]
rp[] = [ 0.0 0.0 10.0 ]
pn[] = [ 0.0 0.0 1.0 ]
pp[] = [ 0.0 0.0 5.0 ]
inter_point rv[] rp[] pn[] pp[] res[]
print res[]

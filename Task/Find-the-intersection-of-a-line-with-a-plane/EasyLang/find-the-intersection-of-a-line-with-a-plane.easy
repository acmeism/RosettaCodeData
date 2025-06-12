func[] minus &l[] &r[] .
   for i to 3 : res[] &= l[i] - r[i]
   return res[]
.
func dot l[] r[] .
   for i to 3 : res += l[i] * r[i]
   return res
.
proc scale &l[] f .
   for i to 3 : l[i] = l[i] * f
.
func[] inter_point &rv[] &rp[] &pn[] &pp[] .
   dif[] = minus rp[] pp[]
   prd1 = dot dif[] pn[]
   prd2 = dot rv[] pn[]
   scale rv[] (prd1 / prd2)
   return minus rp[] rv[]
.
rv[] = [ 0.0 -1.0 -1.0 ]
rp[] = [ 0.0 0.0 10.0 ]
pn[] = [ 0.0 0.0 1.0 ]
pp[] = [ 0.0 0.0 5.0 ]
print inter_point rv[] rp[] pn[] pp[]

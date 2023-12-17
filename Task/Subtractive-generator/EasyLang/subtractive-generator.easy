MOD = 1000000000
len state[] 55
arrbase state[] 0
global si sj .
funcdecl subrand .
proc subrand_seed p1 . .
   p2 = 1
   state[0] = p1 mod MOD
   j = 21
   for i = 1 to 54
      state[j] = p2
      p2 = (p1 - p2) mod MOD
      p1 = state[j]
      j = (j + 21) mod 55
   .
   si = 0
   sj = 24
   for i = 0 to 164
      h = subrand
      h = h
   .
.
func subrand .
   if si = sj
      subrand_seed 0
   .
   si = (si - 1) mod 55
   sj = (sj - 1) mod 55
   x = (state[si] - state[sj]) mod MOD
   state[si] = x
   return x
.
subrand_seed 292929
for i to 10
   print subrand
.

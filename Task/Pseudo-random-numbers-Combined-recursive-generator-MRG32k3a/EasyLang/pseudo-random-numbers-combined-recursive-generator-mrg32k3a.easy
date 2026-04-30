a1[] = [ 0 1403580 -810728 ]
m1 = pow 2 32 - 209
a2[] = [ 527612, 0, -1370589 ]
m2 = pow 2 32 - 22853
d = m1 + 1
x1[] = [ 0 0 0 ]
x2[] = [ 0 0 0 ]
#
proc seed seed_state .
   x1[] = [ seed_state 0 0 ]
   x2[] = [ seed_state 0 0 ]
.
func next_int .
   x1i = (a1[1] * x1[1] + a1[2] * x1[2] + a1[3] * x1[3]) mod m1
   x2i = (a2[1] * x2[1] + a2[2] * x2[2] + a2[3] * x2[3]) mod m2
   x1[] = [ x1i x1[1] x1[2] ]
   x2[] = [ x2i x2[1] x2[2] ]
   z = (x1i - x2i) mod m1
   answer = (z + 1)
   return answer
.
func next_float .
   return next_int / d
.
seed 1234567
for i to 5
   print next_int
.
seed 987654321
len cnt[] 5
for i to 100000
   cnt[floor (next_float * 5) + 1] += 1
.
print cnt[]

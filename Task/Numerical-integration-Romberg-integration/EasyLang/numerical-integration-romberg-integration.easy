# no function pointer
which = 1
e = 2.7182818284
func f x .
   if which = 1
      return sin (x * 180 / pi)
   elif which = 2
      return pow e x
   .
.
func romberg wf a b msteps acc .
   len rp[] msteps
   len rc[] msteps
   which = wf
   h = b - a
   rp[1] = (f (a) + f (b)) * h * 0.5
   for i = 2 to msteps
      h /= 2
      c = 0
      ep = bitshift 1 (i - 2)
      for j = 1 to ep
         c = c + f (a + (2 * j - 1) * h),
      .
      rc[1] = h * c + 0.5 * rp[1]
      for j = 2 to i
         nk = pow 4 (j - 1)
         rc[j] = (nk * rc[j - 1] - rp[j - 1]) / (nk - 1)
      .
      if i > 2 and abs (rp[i - 1] - rc[i]) < acc : return rc[i]
      swap rc[] rp[]
   .
   return rp[$]
.
numfmt 0 8
print romberg 1 0 1 5 1e-8
print romberg 2 -3 3 5 1e-8

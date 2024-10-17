func check t[] .
   len r[] 12
   r[1] = if 12 = 12
   s = 0
   for i = 7 to 12
      s += t[i]
   .
   r[2] = if s = 3
   s = 0
   for i = 2 step 2 to 12
      s += t[i]
   .
   r[3] = if s = 2
   r[4] = 1
   if t[5] = 1
      r[4] = if t[6] + t[7] = 2
   .
   s = 0
   for i = 2 to 4
      s += t[i]
   .
   r[5] = if s = 0
   s = 0
   for i = 1 step 2 to 11
      s += t[i]
   .
   r[6] = if s = 4
   r[7] = if t[2] + t[3] = 1
   r[8] = 1
   if t[7] = 1
      r[8] = if t[5] + t[6] = 2
   .
   s = 0
   for i = 1 to 6
      s += t[i]
   .
   r[9] = if s = 3
   r[10] = if t[11] + t[12] = 2
   s = 0
   for i = 7 to 9
      s += t[i]
   .
   r[11] = if s = 1
   s = 0
   for i = 1 to 11
      s += t[i]
   .
   r[12] = if s = 4
   return if r[] = t[]
.
len t[] 12
for tst = 0 to 4095
   h = tst
   for i to 12
      t[i] = h mod 2
      h = h div 2
   .
   if check t[] = 1
      print t[]
   .
.

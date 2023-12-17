len t[] 12
func f n .
   if n = 1
      return if 12 = 12
   elif n = 2
      for i = 7 to 12
         s += t[i]
      .
      return if s = 3
   elif n = 3
      for i = 2 step 2 to 12
         s += t[i]
      .
      return if s = 2
   elif n = 4
      if t[5] = 1
         return if t[6] + t[7] = 2
      .
      return 1
   elif n = 5
      for i = 2 to 4
         s += t[i]
      .
      return if s = 0
   elif n = 6
      for i = 1 step 2 to 11
         s += t[i]
      .
      return if s = 4
   elif n = 7
      return if t[2] + t[3] = 1
   elif n = 8
      if t[7] = 1
         return if t[5] + t[6] = 2
      .
      return 1
   elif n = 9
      for i = 1 to 6
         s += t[i]
      .
      return if s = 3
   elif n = 10
      return if t[11] + t[12] = 2
   elif n = 11
      for i = 7 to 9
         s += t[i]
      .
      return if s = 1
   elif n = 12
      for i = 1 to 11
         s += t[i]
      .
      return if s = 4
   .
.
for tst = 0 to 4095
   h = tst
   for i to 12
      t[i] = h mod 2
      h = h div 2
   .
   s = 0
   for i to 12
      s += if f i = t[i]
   .
   if s = 12
      print t[]
   .
.

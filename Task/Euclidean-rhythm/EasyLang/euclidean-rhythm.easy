func$ euclrhythm k n .
   for i to n
      h = if i <= k
      s[][] &= [ h ]
   .
   d = n - k
   n = higher k d
   k = lower k d
   z = d
   while z > 0 or k > 1
      for i to k
         for c in s[len s[][] + 1 - i][]
            s[i][] &= c
         .
      .
      len s[][] -k
      z = z - k
      d = n - k
      n = higher k d
      k = lower k d
   .
   for i to len s[][]
      for v in s[i][]
         r$ &= v
      .
   .
   return r$
.
print euclrhythm 3 8

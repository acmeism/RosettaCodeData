global elements[] nperm perma permb digs[] perm[] .
fastproc perminit a b .
   perma = a
   permb = b
   len perm[] a - b
   len elements[] 0
   for i to a : elements[] &= i - 1
   nperm = 1
   for i = b + 1 to a : nperm *= i
.
fastproc mkperm p .
   fa = nperm
   ind = 1
   for i = perma downto permb + 1
      fa /= i
      d = p div fa + 1
      p = p mod fa
      perm[ind] = digs[d]
      for j = d to i - 1
         digs[j] = digs[j + 1]
      .
      ind += 1
   .
.
global send more .
fastfunc test .
   if perm[1] = 0 or perm[5] = 0 : return 0
   send = 0
   for i to 4
      send = 10 * send + perm[i]
   .
   more = 0
   for i = 5 to 7
      more = 10 * more + perm[i]
   .
   more = 10 * more + perm[2]
   money = more div 100
   money = 10 * money + perm[3]
   money = 10 * money + perm[2]
   money = 10 * money + perm[8]
   if send + more = money : return 1
   return 0
.
fastproc sendmore .
   perminit 10 2
   len digs[] len elements[]
   for p = 0 to nperm - 1
      for i to len elements[] : digs[i] = elements[i]
      mkperm p
      if test = 1 : return
   .
.
sendmore
print send & " + " & more & " = " & send + more

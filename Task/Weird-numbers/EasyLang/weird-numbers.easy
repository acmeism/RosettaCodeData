func[] divisors n .
   divs[] &= 1
   for i = 2 to sqrt n
      if n mod i = 0
         j = n / i
         divs[] &= i
         if i <> j
            divs2[] &= j
         .
      .
   .
   for i = len divs2[] downto 1
      divs[] &= divs2[i]
   .
   return divs[]
.
func sum divs[] .
   for e in divs[]
      s += e
   .
   return s
.
func semiperf n divs[] .
   if len divs[] = 0
      return 0
   .
   h = divs[$]
   len divs[] -1
   if n = h
      return 1
   .
   if n > h
      if semiperf (n - h) divs[] = 1
         return 1
      .
   .
   return semiperf n divs[]
.
proc sieve limit . wierd[] .
   len wierd[] limit
   for j = 1 to limit
      if j mod 6 <> 0
         wierd[j] = 1
      .
   .
   for i = 2 step 2 to limit
      if wierd[i] = 1
         divs[] = divisors i
         if i > sum divs[]
            wierd[i] = 0
         elif semiperf i divs[] = 1
            for j = i step i to limit
               wierd[j] = 0
            .
         .
      .
   .
.
sieve 20000 wierd[]
i = 2
repeat
   if wierd[i] = 1
      cnt += 1
      write i & " "
   .
   until cnt = 25
   i += 2
.

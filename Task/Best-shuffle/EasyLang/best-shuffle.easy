proc best_shuffle s$ &r$ &diff .
   l = len s$
   for c$ in strchars s$
      s[] &= strcode c$
   .
   len cnt[] 128
   for i to l
      cnt[s[i]] += 1
      max = higher max cnt[s[i]]
   .
   for i to 128
      while cnt[i] > 0
         cnt[i] -= 1
         buf[] &= i
      .
   .
   r[] = s[]
   for i to l
      for j to l
         if r[i] = buf[j]
            r[i] = buf[(j + max) mod1 l] mod 128
            if buf[j] <= 128
               buf[j] += 128
            .
            break 1
         .
      .
   .
   diff = 0
   r$ = ""
   for i to l
      diff += if r[i] = s[i]
      r$ &= strchar r[i]
   .
.
for s$ in [ "abracadabra" "seesaw" "elk" "grrrrrr" "up" "a" ]
   best_shuffle s$ r$ d
   print s$ & " " & r$ & " " & d
.

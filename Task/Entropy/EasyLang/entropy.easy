func entropy s$ .
   len d[] 255
   for c$ in strchars s$
      d[strcode c$] += 1
   .
   for cnt in d[]
      if cnt > 0
         prop = cnt / len s$
         entr -= (prop * log10 prop / log10 2)
      .
   .
   return entr
.
print entropy "1223334444"

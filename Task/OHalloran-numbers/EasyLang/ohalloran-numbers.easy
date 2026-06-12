len found[] 1000
for l = 1 to 497
   for w = 1 to l
      lw = l * w
      if lw >= 498
         break 1
      .
      for h = 1 to w
         sa = (lw + w * h + h * l) * 2
         if sa <= 1000
            found[sa] = 1
         .
      .
   .
.
for i = 6 step 2 to 998
   if found[i] = 0
      write i & " "
   .
.

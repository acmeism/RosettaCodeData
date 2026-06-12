func abc_word s$ .
   for c$ in strchars s$
      if c$ = "a"
         a += 1
      elif c$ = "b"
         b += 1
      elif c$ = "c"
         c += 1
      .
   .
   return if a = b and a = c
.
words$ = "aluminium abc internet adb cda blank black mercury venus earth mars jupiter saturn uranus neptune pluto"
for w$ in strsplit words$ " "
   if abc_word w$ = 1
      write w$ & " "
   .
.

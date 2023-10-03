func$ strip s$ del$ .
   del$[] = strchars del$
   i = 1
   repeat
      c$ = substr s$ i 1
      until c$ = ""
      for d$ in del$[]
         if c$ = d$
            c$ = ""
         .
      .
      r$ &= c$
      i += 1
   .
   return r$
.
print strip "She was a soul stripper. She took my heart!" "aei"

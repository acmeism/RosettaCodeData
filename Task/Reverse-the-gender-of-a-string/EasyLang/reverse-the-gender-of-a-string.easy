swp$[] = [ "He" "She" "his" "her" ]
func$ rev s$ .
   for c$ in strchars s$
      c = strcode c$
      if c >= 65 and c <= 90 or c >= 97 and c <= 122
         w$ &= c$
      else
         if w$ <> ""
            for i to len swp$[]
               if swp$[i] = w$
                  h = i mod 2 * 2 - 1
                  w$ = swp$[i + h]
                  break 1
               .
            .
            r$ &= w$
            w$ = ""
         .
         r$ &= c$
      .
   .
   return r$
.
r$ = rev "She was a soul stripper. She took his heart!"
print r$
print rev r$

func$[] tokenize src$ sep$ esc$ .
   r$[] = [ "" ]
   for i = 1 to len src$
      c$ = substr src$ i 1
      if esc = 1
         r$[$] &= c$
         esc = 0
      else
         if c$ = sep$
            r$[] &= ""
         elif c$ = esc$
            esc = 1
         else
            r$[$] &= c$
         .
      .
   .
   return r$[]
.
print tokenize "one^|uno||three^^^^|four^^^|^cuatro|" "|" "^"

proc lindenmayer s$ rules$[] count .
   for i to count
      print s$
      nxt$ = ""
      for c$ in strchars s$
         for j = 1 step 2 to len rules$[] - 1
            rep$ = c$
            if c$ = rules$[j]
               rep$ = rules$[j + 1]
               break 1
            .
         .
         nxt$ &= rep$
      .
      s$ = nxt$
   .
.
rules$[] = [ "I", "M", "M", "MI" ]
lindenmayer "I" rules$[] 5

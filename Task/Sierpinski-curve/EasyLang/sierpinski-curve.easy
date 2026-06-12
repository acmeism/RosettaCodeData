func$ lsysexp level axiom$ rules$[] .
   for l to level
      an$ = ""
      for c$ in strchars axiom$
         for i = 1 step 2 to len rules$[]
            if rules$[i] = c$
               c$ = rules$[i + 1]
               break 1
            .
         .
         an$ &= c$
      .
      swap axiom$ an$
   .
   return axiom$
.
proc lsysdraw axiom$ x y ang lng .
   glinewidth 0.3
   gpenup
   glineto x y
   for c$ in strchars axiom$
      if c$ = "F" or c$ = "G"
         x += cos dir * lng
         y += sin dir * lng
         glineto x y
      elif c$ = "-"
         dir -= ang
      elif c$ = "+"
         dir += ang
      .
   .
.
axiom$ = "F--xF--F--xF"
rules$[] = [ "x" "xF+G+xF--F--xF+G+x" ]
curv$ = lsysexp 5 axiom$ rules$[]
lsysdraw curv$ 50 98 45 0.9

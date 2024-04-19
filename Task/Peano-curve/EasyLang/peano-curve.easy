proc lsysexp level . axiom$ rules$[] .
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
.
proc lsysdraw axiom$ x y ang . .
   linewidth 0.3
   move x y
   for c$ in strchars axiom$
      if c$ = "F"
         x += cos dir
         y += sin dir
         line x y
      elif c$ = "-"
         dir -= ang
      elif c$ = "+"
         dir += ang
      .
   .
.
axiom$ = "L"
rules$[] = [ "L" "LFRFL-F-RFLFR+F+LFRFL" "R" "RFLFR+F+LFRFL-F-RFLFR" ]
lsysexp 4 axiom$ rules$[]
lsysdraw axiom$ 5 90 90

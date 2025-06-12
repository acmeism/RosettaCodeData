proc lsysexp level &axiom$ &rules$[] .
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
proc lsysdraw axiom$ x y ang lng .
   glinewidth 0.3
   for c$ in strchars axiom$
      if c$ = "F"
         xp = x
         yp = y
         x += cos dir * lng
         y += sin dir * lng
         gline xp yp x y
      elif c$ = "-"
         dir -= ang
      elif c$ = "+"
         dir += ang
      .
   .
.
axiom$ = "F+XF+F+XF"
rules$[] = [ "X" "XF-F+F-XF+F+XF-F+F-X" ]
lsysexp 4 axiom$ rules$[]
lsysdraw axiom$ 50 10 90 1.4

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
stack[] = [ ]
proc lsysdraw axiom$ x y ang lng .
   glinewidth 0.3
   for c$ in strchars axiom$
      if c$ = "E"
         px = x
         py = y
         x += cos dir * lng
         y += sin dir * lng
         gline px py x y
      elif c$ = "-"
         dir -= ang
      elif c$ = "+"
         dir += ang
      elif c$ = "["
         stack[] &= x
         stack[] &= y
         stack[] &= dir
      elif c$ = "]"
         l = len stack[]
         x = stack[l - 2]
         y = stack[l - 1]
         dir = stack[l]
         len stack[] -3
      .
   .
.
axiom$ = "[b]++[b]++[b]++[b]++[b]"
rules$[] = [ "a" "cE++dE----bE[-cE----aE]++" "b" "+cE--dE[---aE--bE]+" "c" "-aE++bE[+++cE++dE]-" "d" "--cE++++aE[+dE++++bE]--bE" "E" "" ]
lsysexp 6 axiom$ rules$[]
lsysdraw axiom$ 50 50 36 4

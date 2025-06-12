func$ squeeze s$ x$ .
   for c$ in strchars s$
      if c$ <> x$ or c$ <> cc$ : r$ &= c$
      cc$ = c$
   .
   return r$
.
proc do s$ x$ .
   print "'" & x$ & "'"
   print "«««" & s$ & "»»» (" & len s$ & ")"
   r$ = squeeze s$ x$
   print "«««" & r$ & "»»» (" & len r$ & ")"
   print ""
.
do "" " "
do "\"If I were two-faced, would I be wearing this one?\" --- Abraham Lincoln " "-"
do "..1111111111111111111111111111111111111111111111111111111111111117777888" "7"
do "I never give 'em hell, I just tell the truth, and they think it's hell. " "."
do "                                                    --- Harry S Truman  " " "
do "                                                    --- Harry S Truman  " "-"
do "                                                    --- Harry S Truman  " "r"

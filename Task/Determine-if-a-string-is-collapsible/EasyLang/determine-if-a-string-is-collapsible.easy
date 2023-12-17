func$ collapse s$ .
   for c$ in strchars s$
      if c$ <> cc$
         r$ &= c$
      .
      cc$ = c$
   .
   return r$
.
s$[] &= ""
s$[] &= "\"If I were two-faced, would I be wearing this one?\" --- Abraham Lincoln "
s$[] &= "..1111111111111111111111111111111111111111111111111111111111111117777888"
s$[] &= "I never give 'em hell, I just tell the truth, and they think it's hell. "
s$[] &= "                                                    --- Harry S Truman  "
for s$ in s$[]
   print "«««" & s$ & "»»» (" & len s$ & ")"
   r$ = collapse s$
   print "«««" & r$ & "»»» (" & len r$ & ")"
   print ""
.

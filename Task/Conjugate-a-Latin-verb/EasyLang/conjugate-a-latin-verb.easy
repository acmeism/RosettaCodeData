proc conj inf$ .
   if substr inf$ (len inf$ - 2) 3 <> "are"
      print "Not a first conjugation verb."
      return
   .
   stem$ = substr inf$ 1 (len inf$ - 3)
   print "Present indicative tense of " & inf$ & ":"
   for en$ in [ "o" "as" "at" "amus" "atis" "ant" ]
      print stem$ & en$
   .
.
for s$ in [ "amare" "dare" ]
   conj s$
   print ""
.

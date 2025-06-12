func ambtest a$ b$ .
   if substr a$ len a$ 1 = substr b$ 1 1 : return 1
   return 0
.
proc amb &opts$[][] pos prev$ &res$[] &found .
   if pos = 0
      found = 1
      res$[] = [ ]
      return
   .
   for curr$ in opts$[pos][]
      if prev$ = "" or ambtest curr$ prev$ = 1
         amb opts$[][] (pos - 1) curr$ res$[] found
         if found = 1
            res$[] &= curr$
            return
         .
      .
   .
   found = 0
   return
.
proc main .
   sets$[][] = [ [ "the" "that" "a" ] [ "frog" "elephant" "thing" ] [ "walked" "treaded" "grows" ] [ "slowly" "quickly" ] ]
   h = len sets$[][]
   amb sets$[][] h "" res$[] found
   if found = 1
      print res$[]
   .
.
main

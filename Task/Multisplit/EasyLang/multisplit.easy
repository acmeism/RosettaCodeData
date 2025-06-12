proc multisplit str$ sep$[] .
   repeat
      min = 1 / 0
      for sep$ in sep$[]
         pos = strpos str$ sep$
         if pos > 0 and pos < min
            min = pos
            msep$ = sep$
         .
      .
      until min = 1 / 0
      write substr str$ 1 (min - 1) & "{" & msep$ & "}"
      str$ = substr str$ (min + len msep$) 9999
   .
   print str$
.
multisplit "a!===b=!=c" [ "==" "!=" "=" ]

func$ strip s$ .
   i = 1
   repeat
      c$ = substr s$ i 1
      until c$ = "#" or c$ = ";" or c$ = ""
      if c$ = " " and sp = 0
         sp = i
      elif c$ <> " "
         sp = 0
      .
      i += 1
   .
   if sp = 0
      sp = i
   .
   return substr s$ 1 (sp - 1)
.
print strip "Regular string" & "."
print strip "With a hash# a comment" & "."
print strip "With a hash    # a comment" & "."
print strip "With a semicolon   ;  a comment" & "."
print strip "No comment   " & "."

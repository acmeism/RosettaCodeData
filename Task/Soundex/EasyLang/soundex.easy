trans$ = "01230120022455012623010202"
func$ code c$ .
   c = strcode c$ - 64
   if c > 26
      c -= 32
   .
   return substr trans$ c 1
.
func$ soundex s$ .
   code$ = substr s$ 1 1
   prev$ = code code$
   for i = 2 to len s$
      cur$ = code substr s$ i 1
      if cur$ <> "" and cur$ <> "0" and cur$ <> prev$
         code$ &= cur$
      .
      prev$ = cur$
   .
   return substr code$ & "0000" 1 4
.
for v$ in [ "Soundex" "Example" "Sownteks" "Ekzampul" ]
   print soundex v$
.

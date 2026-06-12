func$ txtbetween str$ start$ ende$ .
   s = 1
   if start$ <> "start"
      s = strpos str$ start$
      if s = 0
         return ""
      .
      s += len start$
   .
   str$ = substr str$ s len str$
   e = len str$
   if ende$ <> "end"
      e = strpos str$ ende$
      if e = 0
         return str$
      .
      e -= 1
   .
   return substr str$ 1 e
.
func$ q s$ .
   return "\"" & s$ & "\""
.
texts$[] = [ "Hello Rosetta Code world" "Hello Rosetta Code world" "Hello Rosetta Code world" "</div><div style=\"chinese\">你好嗎</div>" "<text>Hello <span>Rosetta Code</span> world</text><table style=\"myTable\">" "<table style=\"myTable\"><tr><td>hello world</td></tr></table>" "The quick brown fox jumps over the lazy other fox" "One fish two fish red fish blue fish" "FooBarBazFooBuxQuux" ]
starts$[] = [ "Hello " "start" "Hello " "<div style=\"chinese\">" "<text>" "<table>" "quick " "fish " "Foo" ]
ends$[] = [ " world" " world" "end" "</div>" "<table>" "</table>" " fox" " red" "Foo" ]
for i to len texts$[]
   print q texts$[i]
   print q starts$[i] & " : " & q ends$[i]
   print q txtbetween texts$[i] starts$[i] ends$[i]
   print ""
.

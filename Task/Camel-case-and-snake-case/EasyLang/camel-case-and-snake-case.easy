func$ strip s$ .
   a = 1
   while substr s$ a 1 = " "
      a += 1
   .
   b = len s$
   while substr s$ b 1 = " "
      b -= 1
   .
   return substr s$ a (b - a + 1)
.
func$ toupper c$ .
   c = strcode c$
   if c >= 97 and c <= 122
      c$ = strchar (c - 32)
   .
   return c$
.
func$ tolower c$ .
   c = strcode c$
   if c >= 65 and c <= 90
      c$ = strchar (c + 32)
   .
   return c$
.
func isupper c$ .
   c = strcode c$
   if c >= 65 and c <= 90
      return 1
   .
.
delim$ = "_- "
func$ snakecase s$ .
   s$ = strip s$
   for c$ in strchars s$
      if isupper c$ = 1 and prev$ <> ""
         if strpos delim$ prev$ = 0
            r$ &= "_"
         .
         r$ &= tolower c$
      else
         r$ &= c$
      .
      prev$ = c$
   .
   return r$
.
func$ camelcase s$ .
   s$ = strip s$
   prev$ = "x"
   for c$ in strchars s$
      if strpos delim$ prev$ <> 0
         r$ &= toupper c$
      elif strpos delim$ c$ = 0
         r$ &= c$
      .
      prev$ = c$
   .
   return r$
.
test$[] = [ "snakeCase" "snake_case" "variable_10_case" "variable10Case" "ɛrgo rE tHis" "hurry-up-joe!" "c://my-docs/happy_Flag-Day/12.doc" "  spaces  " ]
print "=== To snake_case ==="
for s$ in test$[]
   print s$ & " -> " & snakecase s$
.
print "\n=== To camelCase ==="
for s$ in test$[]
   print s$ & " -> " & camelcase s$
.

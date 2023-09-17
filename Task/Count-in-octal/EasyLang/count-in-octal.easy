func$ oct v .
   while v > 0
      r$ = v mod 8 & r$
      v = v div 8
   .
   if r$ = ""
      r$ = 0
   .
   return r$
.
for i = 0 to 10
   print oct i
.
print "."
print "."
max = pow 2 53
i = max - 10
repeat
   print oct i
   until i = max
   i += 1
.

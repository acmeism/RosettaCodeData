func$ reverse s$ .
   a$[] = strchars s$
   for i = 1 to len a$[] div 2
      swap a$[i] a$[len a$[] - i + 1]
   .
   return strjoin a$[] ""
.
func palin s$ .
   if s$ = reverse s$
      return 1
   .
   return 0
.
for s$ in [ "rotor" "rosetta" "step on no pets" "été" "🦊😀🦊" ]
   if palin s$ = 1
      print s$ & " is a palindrome"
   else
      print s$ & " is not a palindrome"
   .
.

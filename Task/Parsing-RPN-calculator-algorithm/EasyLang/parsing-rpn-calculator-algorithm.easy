func rpn in$ .
   for t$ in strsplit in$ " "
      r = number t$
      if error <> 0
         a = stack[$ - 1]
         b = stack[$]
         len stack[] -2
         if t$ = "+"
            r = a + b
         elif t$ = "-"
            r = a - b
         elif t$ = "*"
            r = a * b
         elif t$ = "/"
            r = a / b
         elif t$ = "^"
            r = pow a b
         else
            print "error: " & t$
         .
      .
      stack[] &= r
      print t$ & " -> " & stack[]
   .
   return stack[1]
.
print rpn ("3 4 2 * 1 5 - 2 3 ^ ^ / +")

func$ toUpper s$ .
   for c$ in strchars s$
      code = strcode c$
      if code >= 97 and code <= 122
         code -= 32
      .
      res$ &= strchar code
   .
   return res$
.
func$ toLower s$ .
   for c$ in strchars s$
      code = strcode c$
      if code >= 65 and code <= 90
         code += 32
      .
      res$ &= strchar code
   .
   return res$
.
string$ = "alphaBETA"
print string$
print toUpper string$
print toLower string$

func$ rmv s$ .
   for c$ in strchars s$
      if strpos "AEIOUaeiou" c$ <> 0
         c$ = ""
      .
      r$ &= c$
   .
   return r$
.
print rmv "The Quick Brown Fox Jumped Over the Lazy Dog's Back"

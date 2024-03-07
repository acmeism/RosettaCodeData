func$ car x$ .
   return substr x$ 1 1
.
func$ cdr x$ .
   return substr x$ 2 9999
.
func$ scs x$ y$ .
   if x$ = ""
      return y$
   .
   if y$ = ""
      return x$
   .
   if car x$ = car y$
      return car x$ & scs cdr x$ cdr y$
   .
   r1$ = scs x$ cdr y$
   r2$ = scs cdr x$ y$
   if len r1$ <= len r2$
      return car y$ & r1$
   else
      return car x$ & r2$
   .
.
print scs "abcbdab" "bdcaba"

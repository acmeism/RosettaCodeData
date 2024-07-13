func$ right a$ n .
   return substr a$ (len a$ - n + 1) n
.
func$ left a$ n .
   if n < 0
      n = len a$ + n
   .
   return substr a$ 1 n
.
func$ lcs a$ b$ .
   if len a$ = 0 or len b$ = 0
      return ""
   .
   if right a$ 1 = right b$ 1
      return lcs left a$ -1 left b$ -1 & right a$ 1
   .
   x$ = lcs a$ left b$ -1
   y$ = lcs left a$ -1 b$
   if len x$ > len y$
      return x$
   else
      return y$
   .
.
print lcs "1234" "1224533324"
print lcs "thisisatest" "testing123testing"

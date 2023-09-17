func$ encr txt$ pw$ d .
   txt$[] = strchars txt$
   for c$ in strchars pw$
      pw[] &= strcode c$ - 65
   .
   for c$ in txt$[]
      c = strcode c$
      if c >= 97
         c -= 32
      .
      if c >= 65 and c <= 97
         pwi = (pwi + 1) mod1 len pw[]
         c = (c - 65 + d * pw[pwi]) mod 26 + 65
         r$ &= strchar c
      .
   .
   return r$
.
s$ = "Beware the Jabberwock, my son! The jaws that bite, the claws that catch!"
pw$ = "VIGENERECIPHER"
r$ = encr s$ pw$ 1
print r$
print encr r$ pw$ -1

func$ crypt str$ key .
   for c$ in strchars str$
      c = strcode c$
      if c >= 65 and c <= 90
         c = (c + key - 65) mod 26 + 65
      elif c >= 97 and c <= 122
         c = (c + key - 97) mod 26 + 97
      .
      enc$ &= strchar c
   .
   return enc$
.
enc$ = crypt "Rosetta Code" 4
print enc$
print crypt enc$ -4

func$ rot13 str$ .
   for c$ in strchars str$
      code = strcode c$
      if code >= 65 and code <= 90
         encCode = code + 13
         if encCode > 90
            encCode = 64 + encCode - 90
         .
      elif code >= 97 and code <= 122
         encCode = code + 13
         if encCode > 122
            encCode = 96 + encCode - 122
         .
      else
         encCode = code
      .
      encStr$ &= strchar encCode
   .
   return encStr$
.
print rot13 "Rosetta Code"

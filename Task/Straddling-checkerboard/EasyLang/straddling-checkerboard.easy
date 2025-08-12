board$ = "ET AON RISBCDFGHJKLMPQ/UVWXYZ."
len encode[] 128
len decode$[] 128
arrbase encode[] 0
arrbase decode$[] 0
len row[] 2
proc init s$ .
   s$[] = strchars s$
   for i = 1 to 30
      if s$[i] = " "
         if row[1] = 0
            row[1] = i - 1
         else
            row[2] = i - 1
         .
      else
         code = 0
         if i > 20
            code = row[2]
         elif i > 10
            code = row[1]
         .
         code = code * 10 + (i - 1) mod 10
         encode[strcode s$[i]] = code
         decode$[code] = s$[i]
      .
   .
.
func$ encipher in$ .
   for c$ in strchars in$
      c = strcode c$
      if c >= 48 and c <= 57
         code = encode[strcode "."]
         r$ &= code
         r$ &= c$
      else
         c = bitand c 0xdf
         if c <> 0
            if c >= 65 and c <= 90
               code = encode[c]
            else
               code = encode[strcode "/"]
            .
            r$ &= code
         .
      .
   .
   return r$
.
func$ decipher in$ .
   in$[] = strchars in$
   for i to len in$[]
      c$ = in$[i]
      c = strcode c$ - 48
      if c = row[1] or c = row[2]
         i += 1
         c = c * 10 + strcode in$[i] - 48
      .
      c$ = decode$[c]
      if c$ = "."
         i += 1
         c$ = in$[i]
      .
      r$ &= c$
   .
   return r$
.
init board$
msg$ = "In the winter 1965/we were hungry/just barely alive"
print msg$
ciph$ = encipher msg$
print ciph$
print decipher ciph$

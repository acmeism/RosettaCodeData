# Lempel-Ziv complexity
proc lz str$ &complexity &subs$ .
   n = len str$
   str$[] = strchars str$
   complexity = 0
   subs$ = ""
   if n > 0
      u = 1
      v = 1
      vmax = v
      complexity = 1
      subs$ = str$[1]
      while u + v <= n
         if str$[i + v] = str$[u + v]
            v += 1
         else
            if v > vmax : vmax = v
            i += 1
            if i = u
               complexity += 1
               subs$ &= "." & substr str$ (u + 1) vmax
               u += vmax
               i = 0
               vmax = 1
            .
            v = 1
         .
      .
      if v <> 1
         complexity += 1
         subs$ &= "." & substr str$ (u + 1) (n - u)
      .
   .
.
numfmt 3 0
print "                          String  LZ Substrings"
print "================================ === ================================================="
tests$[][] = [ [ "AZSEDRFTGYGUJIJOKB" 16 ] [ "ABCABCABCABCABCABC" 4 ] [ "111011111001111011111001" 6 ] [ "101001010010111110" 5 ] [ "1001111011000010" 6 ] [ "1010101010" 3 ] [ "1010101010101010" 3 ] [ "1001111011000010000010" 7 ] [ "100111101100001000001010" 8 ] [ "0001101001000101" 6 ] [ "1111111" 2 ] [ "0001" 2 ] [ "010" 3 ] [ "1" 1 ] [ "" 0 ] [ "01011010001101110010" 7 ] [ "ABCDEFGHIJKLMNOPQRSTUVWXYZ" 26 ] [ "HELLO WORLD! HELLO WORLD! HELLO WORLD! HELLO WORLD!" 11 ] ]
for t to len tests$[][]
   str$ = tests$[t][1]
   expected = number tests$[t][2]
   lz str$ complexity subs$
   if complexity <> expected
      write "**** expected complexity " & expected
      print " for \"" & str$ & "\", got " & complexity
   .
   if len str$ <= 32
      write substr "                                " 1 (32 - len str$) & str$
   else
      print str$
      write "                              ->"
   .
   print " " & complexity & " " & subs$
.

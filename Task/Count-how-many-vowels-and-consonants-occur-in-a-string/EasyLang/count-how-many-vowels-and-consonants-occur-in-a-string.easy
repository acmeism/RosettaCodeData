proc count s$ .
   for c$ in strchars s$
      c = strcode c$
      if c >= 97 and c <= 122 : c -= 32
      if c >= 65 and c <= 91
         c$ = strchar c
         if c$ = "A" or c$ = "E" or c$ = "I" or c$ = "O" or c$ = "U"
            vow += 1
         else
            cons += 1
         .
      .
   .
   print "There are " & vow & " vowels and " & cons & " consonants"
.
count "Now is the time for all good men to come to the aid of their country."

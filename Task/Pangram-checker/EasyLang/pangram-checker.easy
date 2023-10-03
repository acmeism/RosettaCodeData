func pangr s$ .
   len d[] 26
   for c$ in strchars s$
      c = strcode c$
      if c >= 97 and c <= 122
         c -= 32
      .
      if c >= 65 and c <= 91
         d[c - 64] = 1
      .
   .
   for h in d[]
      s += h
   .
   return s
.
repeat
   s$ = input
   until s$ = ""
   print s$
   if pangr s$ = 26
      print "  --> pangram"
   .
   print ""
.
input_data
This is a test.
The quick brown fox jumps over the lazy dog.
The quick brown fox jumped over the lazy dog.
QwErTyUiOpAsDfGhJkLzXcVbNm

func$[] longstr s$ .
   subr maxtest
      if len sub$ >= max
         if len sub$ > max
            max = len sub$
            max$[] = [ ]
         .
         max$[] &= sub$
      .
   .
   s$[] = strchars s$
   len empty[] 255
   len pos[] 255
   pos = 1
   while pos <= len s$[]
      c = strcode s$[pos]
      if pos[c] > 0
         maxtest
         pos = pos[c] + 1
         pos[] = empty[]
         sub$ = ""
         c = strcode s$[pos]
      .
      pos[c] = pos
      sub$ &= strchar c
      pos += 1
   .
   maxtest
   return max$[]
.
for s$ in [ "xyzyabcybdfd" "xyzyab" "zzzzz" "a" "thisisastringtest" "" ]
   print longstr s$
.

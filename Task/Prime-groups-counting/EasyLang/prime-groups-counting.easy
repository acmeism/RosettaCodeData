func isprim n .
   if n < 2 : return 0
   for i = 2 to sqrt n : if n mod i = 0 : return 0
   return 1
.
proc combinations s$ r &result$[] pre$ start .
   if len pre$ = r
      result$[] &= pre$
      return
   .
   for i = start to len s$
      combinations s$ r result$[] pre$ & substr s$ i 1 i + 1
   .
.
func chkgroups cadena$ .
   for i = 1 to len cadena$ - 1 : for j = i + 1 to len cadena$
      c1 = strcode substr cadena$ i 1
      c2 = strcode substr cadena$ j 1
      if isprim abs (c1 - c2) = 0 : return 0
   .
   return 1
.
repeat
   s$ = input
   until s$ = ""
   write s$ & ": "
   for j = 2 to len s$
      combos$[] = [ ]
      combinations s$ j combos$[] "" 1
      for i = 1 to len combos$[]
         if chkgroups combos$[i] = 1 : total += 1
      .
   .
   print total
.
input_data
abcdef
abcdefg

fastfunc isprim num .
   if num < 2 : return 0
   i = 2
   while i <= sqrt num
      if num mod i = 0 : return 0
      i += 1
   .
   return 1
.
func ismagnan n .
   if n < 10 : return 1
   p = 10
   repeat
      q = n div p
      r = n mod p
      if isprim (q + r) = 0 : return 0
      until q < 10
      p *= 10
   .
   return 1
.
proc magnan start stop .
   write start & "-" & stop & ":"
   while count < stop
      if ismagnan i = 1
         count += 1
         if count >= start : write " " & i
      .
      i += 1
   .
   print ""
.
magnan 1 45
magnan 241 250
magnan 391 400

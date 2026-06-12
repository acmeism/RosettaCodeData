fastfunc isprim num .
   i = 2
   while i <= sqrt num
      if num mod i = 0
         return 0
      .
      i += 1
   .
   return 1
.
base = 2
n = 3
repeat
   h = n
   p = 1
   dec = 0
   repeat
      d = h mod 2 + 1
      h = h div 2
      until h = 0
      dec += p * d
      p *= 10
   .
   until dec > 9007199254740992
   if isprim dec = 1
      print dec
      base *= 2
      n = base
   else
      n += 1
   .
.

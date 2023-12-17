func is_cyclops n .
   if n = 0
      return 1
   .
   m = n mod 10
   while m <> 0
      count += 1
      n = n div 10
      m = n mod 10
   .
   n = n div 10
   m = n mod 10
   while m <> 0
      count -= 1
      n = n div 10
      m = n mod 10
   .
   return if n = 0 and count = 0
.
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
func blind n .
   m = n mod 10
   while m <> 0
      k = 10 * k + m
      n = n div 10
      m = n mod 10
   .
   n = n div 10
   while k <> 0
      m = k mod 10
      n = 10 * n + m
      k = k div 10
   .
   return n
.
func is_palindr n .
   l = n
   while l <> 0
      m = l mod 10
      k = 10 * k + m
      l = l div 10
   .
   return if n = k
.
proc show . .
   while cnt < 50
      if is_cyclops i = 1
         write i & " "
         cnt += 1
      .
      i += 1
   .
   print ""
   print ""
   i = 2
   cnt = 0
   while cnt < 50
      if is_cyclops i = 1 and isprim i = 1
         write i & " "
         cnt += 1
      .
      i += 1
   .
   print ""
   print ""
   i = 2
   cnt = 0
   while cnt < 50
      if is_cyclops i = 1 and isprim i = 1
         j = blind i
         if isprim j = 1
            write i & " "
            cnt += 1
         .
      .
      i += 1
   .
   print ""
   print ""
   i = 2
   cnt = 0
   while cnt < 50
      if is_cyclops i = 1 and is_palindr i = 1 and isprim i = 1
         write i & " "
         cnt += 1
      .
      i += 1
   .
.
show

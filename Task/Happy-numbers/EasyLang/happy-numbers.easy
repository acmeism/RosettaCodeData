func dsum n .
   while n > 0
      d = n mod 10
      s += d * d
      n = n div 10
   .
   return s
.
func happy n .
   while n > 999
      n = dsum n
   .
   len seen[] 999
   repeat
      n = dsum n
      until seen[n] = 1
      seen[n] = 1
   .
   return if n = 1
.
while cnt < 8
   n += 1
   if happy n = 1
      cnt += 1
      write n & " "
   .
.

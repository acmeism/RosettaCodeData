fastfunc isprim n .
   if n < 2 : return 0
   i = 2
   while i <= sqrt n
      if n mod i = 0 : return 0
      i += 1
   .
   return 1
.
fastfunc dsum n .
   while n > 0
      d = n mod 10
      s += d * d
      n = n div 10
   .
   return s
.
func happy n .
   while n > 999 : n = dsum n
   len seen[] 999
   repeat
      n = dsum n
      until seen[n] = 1
      seen[n] = 1
   .
   return if n = 1
.
n = 1
den = 3
while cnt < 50
   if isprim n = 1 and happy n = 1
      write n & " "
      cnt += 1
   .
   n += 1
.
print ""
print ""
n = 1
den = 3
repeat
   if happy n = 1
      nh += 1
      if isprim n = 1 : nhp += 1
      if n > 1 and nhp / nh <= 1 / den
         print 1 & "/" & den & "  " & nh & " " & n
         den += 1
      .
   .
   until den > 12
   n += 1
.

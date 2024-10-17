func digsum num .
   while num > 0
      s += num mod 10
      num = num div 10
   .
   return s
.
func[] digrootpers x .
   while x > 9
      x = digsum x
      cnt += 1
   .
   return [ x cnt ]
.
numbers[] = [ 627615 39390 588225 393900588225 ]
for i in numbers[]
   print i & " -> " & digrootpers i
.

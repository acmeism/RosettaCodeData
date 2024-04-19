func gcd a b .
   if b = 0
      return a
   .
   return gcd b (a mod b)
.
proc remove_at i . a[] .
   for j = i + 1 to len a[]
      a[j - 1] = a[j]
   .
   len a[] -1
.
proc yellowstone count . yellow[] .
   yellow[] = [ 1 2 3 ]
   num = 4
   while len yellow[] < count
      yell1 = yellow[len yellow[] - 1]
      yell2 = yellow[len yellow[]]
      for i to len notyellow[]
         test = notyellow[i]
         if gcd yell1 test > 1 and gcd yell2 test = 1
            break 1
         .
      .
      if i <= len notyellow[]
         yellow[] &= notyellow[i]
         remove_at i notyellow[]
      else
         while gcd yell1 num <= 1 or gcd yell2 num <> 1
            notyellow[] &= num
            num += 1
         .
         yellow[] &= num
         num += 1
      .
   .
.
print "First 30 values in the yellowstone sequence:"
yellowstone 30 yellow[]
print yellow[]

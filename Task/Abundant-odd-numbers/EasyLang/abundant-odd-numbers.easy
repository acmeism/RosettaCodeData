fastfunc sumdivs n .
   sum = 1
   i = 3
   while i <= sqrt n
      if n mod i = 0
         sum += i
         j = n / i
         if i <> j
            sum += j
         .
      .
      i += 2
   .
   return sum
.
n = 1
numfmt 6 0
while cnt < 1000
   sum = sumdivs n
   if sum > n
      cnt += 1
      if cnt <= 25 or cnt = 1000
         print cnt & "    n: " & n & " sum: " & sum
      .
   .
   n += 2
.
print ""
n = 1000000001
repeat
   sum = sumdivs n
   until sum > n
   n += 2
.
print "1st > 1B: " & n & " sum: " & sum

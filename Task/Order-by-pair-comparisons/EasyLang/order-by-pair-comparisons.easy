proc insort item$ &arr$[] .
   mid = 1
   lo = 0
   hi = len arr$[] + 1
   while lo + 1 < hi
      mid = (lo + hi) div 2
      repeat
         write "Is " & item$ & " less than " & arr$[mid] & "? y/n: "
         ans$ = input
         print ans$
         until ans$ = "y" or ans$ = "n"
      .
      if ans$ = "y"
         hi = mid
      else
         lo = mid
      .
   .
   arr$[] &= ""
   for i = len arr$[] downto hi + 1
      arr$[i] = arr$[i - 1]
   .
   arr$[hi] = item$
.
items$[] = [ "violet" "red" "green" "indigo" "blue" "yellow" "orange" ]
for item$ in items$[]
   insort item$ ordered$[]
.
print ordered$[]

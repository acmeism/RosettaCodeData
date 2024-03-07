global sb[] .
proc sternbrocot n . .
   sb[] = [ 1 1 ]
   pos = 2
   repeat
      c = sb[pos]
      sb[] &= c + sb[pos - 1]
      sb[] &= c
      pos += 1
      until len sb[] >= n
   .
.
func first v .
   for i to len sb[]
      if v <> 0
         if sb[i] = v
            return i
         .
      else
         if sb[i] <> 0
            return i
         .
      .
   .
   return 0
.
func gcd x y .
   if y = 0
      return x
   .
   return gcd y (x mod y)
.
func$ task5 .
   for i to 1000
      if gcd sb[i] sb[i + 1] <> 1
         return "FAIL"
      .
   .
   return "PASS"
.
sternbrocot 10000
write "Task 2: "
for i to 15
   write sb[i] & " "
.
print "\n\nTask 3:"
for i to 10
   print "\t" & i & " " & first i
.
print "\nTask 4: " & first 100
print "\nTask 5: " & task5

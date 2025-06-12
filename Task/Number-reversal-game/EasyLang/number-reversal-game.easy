func sorted s[] .
   for c in s[]
      if c < last : return 0
      last = c
   .
   return 1
.
func$ tostr s[] .
   for s in s[] : res$ &= s & " "
   return res$
.
proc shuffle &s[] .
   for i = len s[] downto 2
      swap s[i] s[random i]
   .
.
proc reverse n &s[] .
   for i = 1 to n div 2
      swap s[i] s[n - i + 1]
   .
.
data[] = [ 1 2 3 4 5 6 7 8 9 ]
while sorted data[] = 1
   shuffle data[]
.
while sorted data[] = 0
   print tostr data[]
   score += 1
   nflip = number input
   reverse nflip data[]
.
print "Score " & score

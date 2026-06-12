fastfunc isprim num .
   if num mod 2 = 0
      if num = 2 : return 1
      return 0
   .
   if num mod 3 = 0
      if num = 3 : return 1
      return 0
   .
   i = 5
   while i <= sqrt num
      if num mod i = 0 : return 0
      i += 2
      if num mod i = 0 : return 0
      i += 4
   .
   return 1
.
proc digits n &d[] .
   while n > 0
      d[] &= n mod 10
      n = n div 10
   .
.
func fromdigits &d[] b .
   for i = len d[] downto 1 : n = n * b + d[i]
   return n
.
func panbasenpr n .
   if n < 10 : return 1 - isprim n
   if n > 10 and n mod 10 = 0 : return 1
   digits n d[]
   for i to len d[]
      maxdig = higher maxdig d[i]
   .
   for base = maxdig + 1 to n
      n = fromdigits d[] base
      if isprim n = 1 : return 0
   .
   return 1
.
print "First 50 prime pan-base composites:"
n = 2
repeat
   if panbasenpr n = 1
      cnt += 1
      write n & " "
   .
   until cnt = 50
   n += 1
.
cnt = 0
print "\n\nFirst 20 odd prime pan-base composites:"
n = 3
repeat
   if panbasenpr n = 1
      cnt += 1
      write n & " "
   .
   until cnt = 20
   n += 2
.
limit = 10000
cnt = 0
for n = 2 to limit
   if panbasenpr n = 1
      cnt += 1
      if n mod 2 = 1 : odd += 1
   .
.
print "\nCount of pan-base composites up to and including " & limit & ": " & cnt
p = 100 * odd / cnt
print "Percent odd up to and including " & limit & ": " & p
print "Percent even up to and including " & limit & ": " & 100 - p

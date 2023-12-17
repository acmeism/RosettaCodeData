proc hailstone n . list[] .
   list[] = [ ]
   while n <> 1
      list[] &= n
      if n mod 2 = 0
         n = n / 2
      else
         n = 3 * n + 1
      .
   .
   list[] &= 1
.
hailstone 27 l[]
write "27 has length " & len l[] & " with "
for i to 4
   write l[i] & " "
.
write "... "
for i = len l[] - 3 to len l[]
   write l[i] & " "
.
print ""
for i = 1 to 100000
   hailstone i l[]
   if len l[] >= max_iter
      max_i = i
      max_iter = len l[]
   end
end
print max_i & " has length " & max_iter

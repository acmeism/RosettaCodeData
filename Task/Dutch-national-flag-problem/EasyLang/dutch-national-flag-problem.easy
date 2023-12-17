col$[] = [ "red" "white" "blue" ]
for i to 8
   b[] &= random 3
.
for b in b[]
   write col$[b] & " "
   if b < b0
      not_sorted = 1
   .
   b0 = b
.
print ""
print ""
if not_sorted = 0
   print "already sorted"
else
   for i = 1 to len b[] - 1
      for j = i + 1 to len b[]
         if b[j] < b[i]
            swap b[j] b[i]
         .
      .
   .
   for b in b[]
      write col$[b] & " "
   .
.

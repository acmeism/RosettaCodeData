proc farey n . .
   b = 1 ; c = 1 ; d = n
   write n & ": "
   repeat
      if n <= 11
         write " " & a & "/" & b
      .
      until c > n
      k = (n + b) div d
      aa = c ; bb = d ; cc = k * c - a ; dd = k * d - b
      a = aa ; b = bb ; c = cc ; d = dd
      items += 1
   .
   if n > 11
      print items & " items"
   else
      print ""
   .
.
for i = 1 to 11
   farey i
.
for i = 100 step 100 to 1000
   farey i
.

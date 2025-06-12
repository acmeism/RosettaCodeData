fastfunc humble i .
   if i <= 1 : return 1
   if i mod 2 = 0 : return humble (i / 2)
   if i mod 3 = 0 : return humble (i / 3)
   if i mod 5 = 0 : return humble (i / 5)
   if i mod 7 = 0 : return humble (i / 7)
   return 0
.
fastfunc next_humble n .
   repeat
      n += 1
      until humble n = 1
   .
   return n
.
len arr[] 9
while cnt < 5193
   n = next_humble n
   arr[log10 n + 1] += 1
   cnt += 1
   if cnt <= 50 : write n & " "
.
print ""
print ""
for i to 9 : print arr[i] & " with " & i & " digits"

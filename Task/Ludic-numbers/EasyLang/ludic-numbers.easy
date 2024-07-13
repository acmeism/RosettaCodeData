proc initLudicArray n . res[] .
   len res[] n
   res[1] = 1
   for i = 2 to n
      k = 0
      for j = i - 1 downto 2
         k = k * res[j] div (res[j] - 1) + 1
      .
      res[i] = k + 2
   .
.
initLudicArray 2005 arr[]
for i = 1 to 25
   write arr[i] & " "
.
print ""
print ""
i = 1
while arr[i] <= 1000
   cnt += 1
   i += 1
.
print cnt
print ""
for i = 2000 to 2005
   write arr[i] & " "
.

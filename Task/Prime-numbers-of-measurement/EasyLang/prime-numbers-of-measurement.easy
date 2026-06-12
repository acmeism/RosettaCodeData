len prmeas[] 1000
prmeas[1] = 1
prind = 2
next = 2
while prind <= 1000
   for i = 1 to prind - 1
      sum = 0
      for j = i to prind - 1
         sum += prmeas[j]
         if sum >= next : break 1
      .
      if sum = next : break 1
   .
   if sum <> next
      prmeas[prind] = next
      prind += 1
   .
   next += 1
.
print "First 100:"
for i to 100 : write prmeas[i] & " "
print ""
print ""
print "One Thousandth: " & prmeas[1000]

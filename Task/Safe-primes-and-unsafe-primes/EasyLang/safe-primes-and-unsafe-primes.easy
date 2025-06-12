fastfunc isprim num .
   if num < 2 : return 0
   if num mod 2 = 0
      if num = 2 : return 1
      return 0
   .
   i = 3
   while i <= sqrt num
      if num mod i = 0 : return 0
      i += 2
   .
   return 1
.
print "First 35 safe primes:"
for i = 2 to 999999
   if isprim i = 1 and isprim ((i - 1) / 2) = 1
      if count < 35 : write i & " "
      count += 1
   .
.
print ""
print "There are " & count & " safe primes below 1000000"
for i = i to 9999999
   if isprim i = 1 and isprim ((i - 1) / 2) = 1
      count += 1
   .
.
print "There are " & count & " safe primes below 10000000"
print ""
count = 0
print "First 40 unsafe primes:"
for i = 2 to 999999
   if isprim i = 1 and isprim ((i - 1) / 2) = 0
      if count < 40 : write i & " "
      count += 1
   .
.
print ""
print "There are " & count & " unsafe primes below 1000000"
for i = i to 9999999
   if isprim i = 1 and isprim ((i - 1) / 2) = 0
      count += 1
   .
.
print "There are " & count & " unsafe primes below 10000000"

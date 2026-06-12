func isprim num .
   i = 2
   while i <= sqrt num
      if num mod i = 0
         return 0
      .
      i += 1
   .
   return 1
.
subr init
   a_ = 1
   b_ = 0
   digits_ = 3
   max_ = pow 2 53 - 1
.
func nxtundul .
   for d = 1 to digits_
      if d mod 2 = 1
         n = n * 10 + a_
      else
         n = n * 10 + b_
      .
      if n > max_
         return 0
      .
   .
   b_ += 1
   if a_ = b_
      b_ += 1
   .
   if b_ = 10
      a_ += 1
      b_ = 0
      if a_ = 10
         a_ = 1
         digits_ += 1
      .
   .
   return n
.
init
while digits_ = 3
   write nxtundul & " "
.
print "\n"
while digits_ = 4
   write nxtundul & " "
.
print "\n"
init
while digits_ = 3
   h = nxtundul
   if isprim h = 1
      write h & " "
   .
.
print "\n"
init
for i to 600
   h = nxtundul
.
print h
print ""
init
repeat
   last = h
   h = nxtundul
   until h = 0
   cnt += 1
.
print cnt & " " & last

fastfunc isprim n .
   if n < 2 : return 0
   i = 2
   while i <= sqrt n
      if n mod i = 0 : return 0
      i += 1
   .
   return 1
.
subr jtinit
   jtcurr = 0
   jtnext = 1
.
proc jtstep .
   swap jtnext jtcurr
   jtnext += jtnext + jtcurr
.
print "First 30 Jacobsthal numbers:"
jtinit
for i to 30
   write jtcurr & " "
   jtstep
.
print ""
print "\nFirst 30 Jacobsthal-Lucas numbers:"
jtinit
jtcurr = 2
for i to 30
   write jtcurr & " "
   jtstep
.
print ""
print "\nFirst 20 Jacobsthal oblong numbers:"
jtinit
for i to 20
   write jtcurr * jtnext & " "
   jtstep
.
print ""
print "\nFirst 10 Jacobsthal prime numbers:"
jtinit
while cnt < 10
   jtstep
   if isprim jtnext = 1
      write jtnext & " "
      cnt += 1
   .
   i += 1
.
print ""

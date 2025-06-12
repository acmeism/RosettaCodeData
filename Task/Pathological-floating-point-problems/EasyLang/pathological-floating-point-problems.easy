numfmt 0 10
proc task1 .
   print "--- Task 1 pathologic ---"
   vpp = 2
   vp = -4
   for i = 3 to 100
      v = 111 - 1130 / vp + 3000 / (vp * vpp)
      if i <= 8 or i = 20 or i = 30 or i = 50 or i = 100
         print i & ": " & v
      .
      vpp = vp
      vp = v
   .
.
task1
print ""
#
proc task2 .
   print "--- Task 2 pathologic ---"
   e = 2.718281828459045
   bal = e - 1
   for i = 1 to 25
      bal = bal * i - 1
   .
   print "Balance after 25 years: $" & bal
.
task2
print ""
#
proc mul f &bal &bal$[] .
   for i = len bal$[] downto 1
      dig = number bal$[i]
      h = dig * f + c
      bal$[i] = h mod 10
      c = h div 10
   .
   bal += c
.
proc task2ok .
   print "--- Task 2 OK ---"
   e$ = "2.7182818284590452353602874713526624977572470"
   bal = number substr e$ 1 1
   bal$[] = strchars substr e$ 3 999
   bal -= 1
   for i = 1 to 25
      mul i bal bal$[]
      bal -= 1
   .
   print "Balance after 25 years: $" & bal & "." & substr strjoin bal$[] "" 1 16
.
task2ok

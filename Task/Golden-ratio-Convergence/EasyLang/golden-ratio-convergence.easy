phi0 = 1
repeat
   phi = 1 + 1 / phi0
   until abs (phi - phi0) < 1e-5
   phi0 = phi
   iter += 1
.
numfmt 0 10
print "Iterations: " & iter
print "Result: " & phi
print "Error: " & phi - (1 + sqrt 5) / 2

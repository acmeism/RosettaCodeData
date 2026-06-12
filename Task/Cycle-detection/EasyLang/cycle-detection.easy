func f x .
   return (x * x + 1) mod 255
.
proc brent x0 &lam &mu &tab[] .
   power = 1
   lam = 1
   tort = x0
   hare = f x0
   tab[] = [ tort hare ]
   while tort <> hare
      if power = lam
         tort = hare
         power = power * 2
         lam = 0
      .
      hare = f hare
      tab[] &= hare
      lam += 1
   .
   tort = x0
   hare = x0
   for i = 1 to lam : hare = f hare
   # one based
   mu = 1
   while tort <> hare
      tort = f tort
      hare = f hare
      mu += 1
   .
.
x0 = 3
brent x0 le start tab[]
print tab[]
print "cycle length: " & le & " start index: " & start

K = 7.8e9
N0 = 27
e = 2.7182818284
Actual[] = [ 27 27 27 44 44 59 59 59 59 59 59 59 59 60 60 61 61 66 83 219 239 392 534 631 897 1350 2023 2820 4587 6067 7823 9826 11946 14554 17372 20615 24522 28273 31491 34933 37552 40540 43105 45177 60328 64543 67103 69265 71332 73327 75191 75723 76719 77804 78812 79339 80132 80995 82101 83365 85203 87024 89068 90664 93077 95316 98172 102133 105824 109695 114232 118610 125497 133852 143227 151367 167418 180096 194836 213150 242364 271106 305117 338133 377918 416845 468049 527767 591704 656866 715353 777796 851308 928436 1000249 1082054 1174652 ]
numfmt 0 6
func f r .
   for i to len Actual[]
      eri = pow e (r * (i - 1))
      guess = (N0 * eri) / (1 + N0 * (eri - 1) / K)
      diff = guess - Actual[i]
      sq += diff * diff
   .
   return sq
.
func solve guess epsilon .
   delta = 1
   if guess <> 0 : delta = guess
   f0 = f guess
   factor = 2
   while delta > epsilon and guess <> guess - delta
      nf = f (guess - delta)
      if nf < f0
         f0 = nf
         guess -= delta
      else
         nf = f (guess + delta)
         if nf < f0
            f0 = nf
            guess += delta
         else
            factor = 0.5
         .
      .
      delta *= factor
   .
   return guess
.
r = solve 0.5 0.0
r0 = pow e (12 * r)
print "r = " & r & ", R0 = " & r0

multiplier[] = [ 1 3 5 7 11 3 * 5 3 * 7 3 * 11 5 * 7 5 * 11 7 * 11 3 * 5 * 7 3 * 5 * 11 3 * 7 * 11 5 * 7 * 11 3 * 5 * 7 * 11 ]
func gcd a b .
   while b <> 0
      a = a mod b
      swap a b
   .
   return a
.
func squfof N .
   s = floor (sqrt N + 0.5)
   if s * s = N
      return s
   .
   for multiplier in multiplier[]
      if N > 9007199254740992 / multiplier
         print "Number " & N & " is too big"
         break 1
      .
      D = multiplier * N
      P = floor sqrt D
      Po = P
      Pprev = P
      Qprev = 1
      Q = D - Po * Po
      L = 2 * floor sqrt (2 * s)
      B = 3 * L
      for i = 2 to B - 1
         b = (Po + P) div Q
         P = b * Q - P
         q = Q
         Q = Qprev + b * (Pprev - P)
         r = floor (sqrt Q + 0.5)
         if i mod 2 = 0 and r * r = Q
            break 1
         .
         Qprev = q
         Pprev = P
      .
      if i < B
         b = (Po - P) div r
         P = b * r + P
         Pprev = P
         Qprev = r
         Q = (D - Pprev * Pprev) / Qprev
         i = 0
         repeat
            b = (Po + P) div Q
            Pprev = P
            P = b * Q - P
            q = Q
            Q = Qprev + b * (Pprev - P)
            Qprev = q
            i += 1
            until P = Pprev
         .
         r = gcd N Qprev
         if r <> 1 and r <> N
            return r
         .
      .
   .
   return 0
.
data[] = [ 2501 12851 13289 75301 120787 967009 997417 7091569 13290059 42854447 223553581 2027651281 11111111111 100895598169 1002742628021 60012462237239 287129523414791 9007199254740931 ]
for example in data[]
   factor = squfof example
   if factor = 0
      print example & " was not factored."
   else
      quotient = example / factor
      print example & " has factors " & factor & " " & quotient
   .
.

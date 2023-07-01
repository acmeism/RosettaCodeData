let pyth n = [ for a in [1..n] do
               for b in [a..n] do
               for c in [b..n] do
               if (a*a+b*b = c*c) then yield (a,b,c)]

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
proc carmichael3 p1 . .
   for h3 = 1 to p1 - 1
      for d = 1 to h3 + p1 - 1
         if (h3 + p1) * (p1 - 1) mod d = 0 and -p1 * p1 mod h3 = d mod h3
            p2 = 1 + (p1 - 1) * (h3 + p1) div d
            if isprim p2 = 1
               p3 = 1 + (p1 * p2 div h3)
               if isprim p3 = 1 and (p2 * p3) mod (p1 - 1) = 1
                  print p1 & " " & p2 & " " & p3
               .
            .
         .
      .
   .
.
for p1 = 2 to 61
   if isprim p1 = 1
      carmichael3 p1
   .
.

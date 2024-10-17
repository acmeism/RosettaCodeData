max = 13
desc$[] = [ "90°, a²+b²=c²" "60°, a²+b²-ab=c²" "120°, a²+b²+ab=c²" ]
cos3[] = [ 0 1 -1 ]
for k = 1 to 3
   cnt = 0
   print desc$[k]
   for a = 1 to max
      for b = 1 to a
         cc = a * a + b * b - cos3[k] * a * b
         c = sqrt cc
         if c <= 13 and c = floor c
            write "(" & a & " " & b & " " & c & ") "
            cnt += 1
         .
      .
   .
   print ""
   print cnt & " triangles"
   print ""
.

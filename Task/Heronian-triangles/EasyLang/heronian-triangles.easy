func gcd x y .
   if y = 0 : return x
   return gcd y (x mod y)
.
global ta[] tb[] tc[] .
proc mktbl .
   for c = 1 to 200 : for b = 1 to c : for a = 1 to b
      s = (a + b + c) / 2
      ar = sqrt (s * (s - a) * (s - b) * (s - c))
      if ar > 0 and ar = floor ar and gcd gcd b c a = 1
         ta[] &= a
         tb[] &= b
         tc[] &= c
      .
   .
.
mktbl
#
proc get i &a &b &c &per &ar .
   a = ta[i]
   b = tb[i]
   c = tc[i]
   per = a + b + c
   s = per / 2
   ar = sqrt (s * (s - a) * (s - b) * (s - c))
.
func wgt i .
   get i a b c per ar
   return ar * 1000000 + per * 1000 + a
.
proc sort .
   for i = 1 to len ta[] - 1
      for j = i + 1 to len ta[]
         if wgt j < wgt i
            swap ta[j] ta[i]
            swap tb[j] tb[i]
            swap tc[j] tc[i]
         .
      .
   .
.
sort
#
print "Number of triangles: " & len ta[]
print ""
numfmt 2 2
for i = 1 to 10
   get i a b c per ar
   print "(" & a & " " & b & " " & c & ") Perim: " & per & " Area: " & ar
.
print ""
for i = 1 to len ta[]
   get i a b c per ar
   if ar = 210
      print "(" & a & " " & b & " " & c & ") Perim: " & per & " Area: " & ar
   .
.

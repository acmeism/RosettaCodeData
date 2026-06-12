func isdopey n .
   while n mod 2 = 0
      h += 1
      n = n div 2
   .
   return h mod 2
.
proc show25 what .
   while cnt < 25
      i += 1
      if isdopey i = what
         cnt += 1
         write i & " "
      .
   .
   print ""
   print ""
.
show25 0
show25 1
#
upto = 2
while upto <= 1024
   i += 1
   h = isdopey i
   nd += h
   nv += 1 - h
   if i = upto
      write upto & ":" & "\t"
      print nv & "\t" & nd
      upto *= 2
   .
.

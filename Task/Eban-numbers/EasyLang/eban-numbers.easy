func x n .
   if n = 0 or n = 2 or n = 4 or n = 6 : return 1
   return 0
.
proc go start stop printable .
   write start & " - " & stop & ":"
   for i = start step 2 to stop
      b = i div 1000000000
      r = i mod 1000000000
      m = r div 1000000
      r = i mod 1000000
      t = r div 1000
      r = r mod 1000
      if m >= 30 and m <= 66 : m = m mod 10
      if t >= 30 and t <= 66 : t = t mod 10
      if r >= 30 and r <= 66 : r = r mod 10
      if x b = 1 and x m = 1 and x t = 1 and x r = 1
         count += 1
         if printable = 1 : write " " & i
      .
   .
   print " (count=" & count & ")"
.
go 2 1000 1
go 1000 4000 1
go 2 10000 0
go 2 100000 0
go 2 1000000 0
go 2 10000000 0
go 2 100000000 0

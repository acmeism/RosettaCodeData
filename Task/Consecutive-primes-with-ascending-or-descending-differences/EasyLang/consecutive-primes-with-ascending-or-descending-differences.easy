fastfunc nextprim num .
   repeat
      i = 2
      while i <= sqrt num and num mod i <> 0
         i += 1
      .
      until num mod i <> 0
      num += 1
   .
   return num
.
proc getseq dir . maxprim maxcnt .
   maxcnt = 0
   pri = 2
   repeat
      prev = pri
      pri = nextprim (pri + 1)
      until pri > 1000000
      d0 = d
      d = (pri - prev) * dir
      if d > d0
         cnt += 1
      else
         if cnt > maxcnt
            maxcnt = cnt
            maxprim = prim0
         .
         prim0 = prev
         cnt = 1
      .
   .
.
proc outseq pri max . .
   write pri & " "
   for i to max
      pri = nextprim (pri + 1)
      write pri & " "
   .
   print ""
.
getseq 1 pri max
outseq pri max
getseq -1 pri max
outseq pri max
